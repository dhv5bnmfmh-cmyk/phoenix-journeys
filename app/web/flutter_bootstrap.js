{{flutter_js}}
{{flutter_build_config}}

const loading = document.getElementById('phoenix-loading');
const loadingText = document.getElementById('phoenix-loading-text');
const phoenixTraveler = document.querySelector('.phoenix-loading__traveler');
const phoenixFlightAnimationName = 'phoenix-time-flight-v2';
const legacyWorkerResetKey = 'phoenix-legacy-flutter-worker-reset';

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

function waitForPhoenixFlight() {
  if (!phoenixTraveler) {
    const finishedAt = logStartupTimestamp('PHOENIX FLIGHT END');
    return Promise.resolve({ finishedAt, animationActive: false });
  }

  const animations = typeof phoenixTraveler.getAnimations === 'function'
    ? phoenixTraveler.getAnimations()
    : [];
  const phoenixFlight = animations.find((animation) => {
    return animation.animationName === phoenixFlightAnimationName;
  });

  if (phoenixFlight) {
    return phoenixFlight.finished.then(
      () => ({
        finishedAt: logStartupTimestamp('PHOENIX FLIGHT END'),
        animationActive: true,
      }),
      () => ({
        finishedAt: logStartupTimestamp('PHOENIX FLIGHT END'),
        animationActive: false,
      }),
    );
  }

  const animationNames = window.getComputedStyle(phoenixTraveler)
    .animationName
    .split(',')
    .map((name) => name.trim());
  if (!animationNames.includes(phoenixFlightAnimationName)) {
    const finishedAt = logStartupTimestamp('PHOENIX FLIGHT END');
    return Promise.resolve({ finishedAt, animationActive: false });
  }

  return new Promise((resolve) => {
    const finish = (event, animationActive) => {
      if (event.animationName !== phoenixFlightAnimationName) {
        return;
      }
      phoenixTraveler.removeEventListener('animationend', onAnimationEnd);
      phoenixTraveler.removeEventListener('animationcancel', onAnimationCancel);
      resolve({
        finishedAt: logStartupTimestamp('PHOENIX FLIGHT END'),
        animationActive,
      });
    };
    const onAnimationEnd = (event) => finish(event, true);
    const onAnimationCancel = (event) => finish(event, false);
    phoenixTraveler.addEventListener('animationend', onAnimationEnd);
    phoenixTraveler.addEventListener('animationcancel', onAnimationCancel);
  });
}

const phoenixFlightFinished = waitForPhoenixFlight();

function hideLoading({ flightEndAt, runAppReadyAt, animationActive }) {
  if (!loading) {
    return;
  }

  const coverFadeStartedAt = logStartupTimestamp('COVER FADE START');
  if (animationActive) {
    const finalFrameExtraWait = Math.max(0, coverFadeStartedAt - flightEndAt);
    console.info(`FINAL-FRAME EXTRA WAIT = ${finalFrameExtraWait.toFixed(1)}ms`);
  }
  console.info(`FLUTTER runApp READY = ${runAppReadyAt.toFixed(1)}ms`);

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
        const [runAppReadyAt, flight] = await Promise.all([
          appRunner.runApp().then(() => logStartupTimestamp('FLUTTER runApp READY')),
          phoenixFlightFinished,
        ]);
        hideLoading({
          flightEndAt: flight.finishedAt,
          runAppReadyAt,
          animationActive: flight.animationActive,
        });
      },
    });
  } catch (error) {
    console.error('Phoenix Journeys failed to start.', error);
    showLoadingError();
  }
})();
