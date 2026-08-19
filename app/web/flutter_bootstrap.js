{{flutter_js}}
{{flutter_build_config}}

const loading = document.getElementById('phoenix-loading');
const loadingText = document.getElementById('phoenix-loading-text');
const bootstrapStartedAt = window.performance.now();
const phoenixFlightDurationMs = 6800;
const phoenixBrandingDeadlineAt = bootstrapStartedAt + phoenixFlightDurationMs;
const legacyWorkerResetKey = 'phoenix-legacy-flutter-worker-reset';

let homeReadyAt = null;
let resolveStartupSettled;
const startupSettled = new Promise((resolve) => {
  resolveStartupSettled = resolve;
});

function updateLoadingText(message) {
  if (loadingText) {
    loadingText.textContent = message;
  }
}

function logStartupTimestamp(label) {
  const timestamp = window.performance.now();
  console.info(`${label} = ${timestamp.toFixed(1)}ms`);
  return timestamp;
}

window.addEventListener(
  'phoenix-startup-settled',
  (event) => {
    const status = event?.detail === 'error' ? 'error' : 'ready';
    const settledAt = logStartupTimestamp(
      status === 'ready' ? 'HOME READY' : 'STARTUP ERROR READY',
    );
    if (status === 'ready') {
      homeReadyAt = settledAt;
    }
    resolveStartupSettled({ status, settledAt });
  },
  { once: true },
);

const brandingDeadline = new Promise((resolve) => {
  const remaining = Math.max(
    0,
    phoenixBrandingDeadlineAt - window.performance.now(),
  );
  window.setTimeout(() => {
    const reachedAt = window.performance.now();
    console.info(`PHOENIX FLIGHT = ${(phoenixFlightDurationMs / 1000).toFixed(1)}s`);
    console.info(`PHOENIX BRANDING DEADLINE = ${phoenixBrandingDeadlineAt.toFixed(1)}ms`);
    console.info(`PHOENIX BRANDING TIMER RESUMED = ${reachedAt.toFixed(1)}ms`);
    if (homeReadyAt == null) {
      console.info('HOME READY AT PHOENIX FLIGHT END = PENDING');
    }
    resolve({ deadlineAt: phoenixBrandingDeadlineAt, reachedAt });
  }, remaining);
});

function hideLoading({ brandingDeadlineAt, runAppReadyAt, startup }) {
  if (!loading) {
    return;
  }

  const coverFadeStartedAt = logStartupTimestamp('COVER FADE START');
  const finalFrameExtraWait = Math.max(
    0,
    coverFadeStartedAt - brandingDeadlineAt,
  );
  console.info(`FINAL-FRAME EXTRA WAIT = ${finalFrameExtraWait.toFixed(1)}ms`);
  console.info(`FLUTTER runApp READY = ${runAppReadyAt.toFixed(1)}ms`);
  if (startup.status === 'ready') {
    console.info(`HOME READY = ${startup.settledAt.toFixed(1)}ms`);
  }

  loading.classList.add('phoenix-loading--hidden');
  window.setTimeout(() => loading.remove(), 760);
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
        const runAppReadyAt = await appRunner
          .runApp()
          .then(() => logStartupTimestamp('FLUTTER runApp READY'));
        const [branding, startup] = await Promise.all([
          brandingDeadline,
          startupSettled,
        ]);
        hideLoading({
          brandingDeadlineAt: branding.deadlineAt,
          runAppReadyAt,
          startup,
        });
      },
    });
  } catch (error) {
    console.error('Phoenix Journeys failed to start.', error);
    showLoadingError();
  }
})();
