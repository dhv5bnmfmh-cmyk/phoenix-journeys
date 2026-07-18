{{flutter_js}}
{{flutter_build_config}}

const loading = document.getElementById('phoenix-loading');
const loadingText = document.getElementById('phoenix-loading-text');
const legacyWorkerResetKey = 'phoenix-legacy-flutter-worker-reset';

function updateLoadingText(message) {
  if (loadingText) {
    loadingText.textContent = message;
  }
}

function hideLoading() {
  if (!loading) {
    return;
  }

  loading.classList.add('phoenix-loading--hidden');
  window.setTimeout(() => loading.remove(), 260);
}

function showLoadingError() {
  updateLoadingText('旅程暂时无法打开，请检查网络后刷新页面。');
  if (loading) {
    loading.setAttribute('aria-live', 'assertive');
  }
}

function isLegacyFlutterWorker(worker) {
  if (!worker || !worker.scriptURL) {
    return false;
  }

  try {
    const scriptUrl = new URL(worker.scriptURL, window.location.href);
    return scriptUrl.pathname.endsWith('/flutter_service_worker.js');
  } catch (_) {
    return false;
  }
}

async function retireLegacyFlutterWorker() {
  if (!('serviceWorker' in navigator)) {
    return false;
  }

  try {
    const registrations = await navigator.serviceWorker.getRegistrations();
    const legacyRegistrations = registrations.filter((registration) => {
      return [registration.active, registration.waiting, registration.installing]
        .some(isLegacyFlutterWorker);
    });
    const controllerIsLegacy = isLegacyFlutterWorker(
      navigator.serviceWorker.controller,
    );

    if (legacyRegistrations.length === 0 && !controllerIsLegacy) {
      return false;
    }

    updateLoadingText('正在更新 Phoenix 到最新版本…');
    await Promise.all(
      legacyRegistrations.map((registration) => registration.unregister()),
    );

    if ('caches' in window) {
      const cacheNames = await window.caches.keys();
      const legacyCacheNames = cacheNames.filter((name) => {
        return name === 'flutter-app-cache' ||
          name === 'flutter-temp-cache' ||
          name.startsWith('flutter-');
      });
      await Promise.all(
        legacyCacheNames.map((name) => window.caches.delete(name)),
      );
    }

    return true;
  } catch (error) {
    console.warn('Phoenix could not retire the legacy Flutter cache.', error);
    return false;
  }
}

function reloadAfterLegacyWorkerRetirement() {
  if (!isLegacyFlutterWorker(navigator.serviceWorker.controller)) {
    return false;
  }

  try {
    if (window.sessionStorage.getItem(legacyWorkerResetKey) === 'done') {
      return false;
    }
    window.sessionStorage.setItem(legacyWorkerResetKey, 'done');
  } catch (_) {
    // Reload once even when Safari blocks session storage in private mode.
  }

  window.location.reload();
  return true;
}

(async () => {
  try {
    const retiredLegacyWorker = await retireLegacyFlutterWorker();
    if (retiredLegacyWorker && reloadAfterLegacyWorkerRetirement()) {
      return;
    }

    await _flutter.loader.load({
      onEntrypointLoaded: async (engineInitializer) => {
        updateLoadingText('正在启动旅行引擎…');
        const appRunner = await engineInitializer.initializeEngine();
        updateLoadingText('正在打开 Phoenix…');
        await appRunner.runApp();
        hideLoading();
      },
    });
  } catch (error) {
    console.error('Phoenix Journeys failed to start.', error);
    showLoadingError();
  }
})();
