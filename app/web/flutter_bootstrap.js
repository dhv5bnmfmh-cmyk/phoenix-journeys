{{flutter_js}}
{{flutter_build_config}}

const cover = document.getElementById('phoenix-loading');
const traveler = cover?.querySelector('.phoenix-time-traveler') ?? null;
const loadingStartedAt = performance.now();
const minimumJourneyDurationMs = 3200;
const phoenixFlightDurationMs = 3200;
const legacyWorkerResetKey = 'phoenix-legacy-flutter-worker-reset';
let coverHidden = false;
let hoverAnimation = null;

window.__phoenixStartupTiming = {
  minimumJourneyDurationMs,
  phoenixFlightDurationMs,
};

function mark(name) {
  try {
    performance.mark(name);
  } catch (_) {}
}

function isLegacyFlutterWorker(worker) {
  if (!worker || !worker.scriptURL) return false;
  try {
    const scriptUrl = new URL(worker.scriptURL, window.location.href);
    return scriptUrl.pathname.endsWith('/flutter_service_worker.js');
  } catch (_) {
    return false;
  }
}

async function retireLegacyFlutterWorker() {
  if (!('serviceWorker' in navigator)) return false;

  try {
    const registrations = await navigator.serviceWorker.getRegistrations();
    const legacyRegistrations = registrations.filter((registration) => {
      return [registration.active, registration.waiting, registration.installing]
        .some(isLegacyFlutterWorker);
    });
    const controllerIsLegacy = isLegacyFlutterWorker(
      navigator.serviceWorker.controller,
    );

    if (legacyRegistrations.length === 0 && !controllerIsLegacy) return false;

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
  if (!isLegacyFlutterWorker(navigator.serviceWorker.controller)) return false;

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

mark('phoenix-cover-created');

if (traveler) {
  traveler.addEventListener('animationstart', (event) => {
    if (event.animationName === 'phoenix-time-flight-v2') {
      mark('phoenix-flight-start');
    }
  }, {passive: true});
  traveler.addEventListener('animationend', (event) => {
    if (event.animationName !== 'phoenix-time-flight-v2') return;
    mark('phoenix-flight-end');
    if (!coverHidden && typeof traveler.animate === 'function') {
      hoverAnimation = traveler.animate(
        [
          {transform: 'translateY(0) scale(1)', filter: 'brightness(1)'},
          {transform: 'translateY(-5px) scale(1.025)', filter: 'brightness(1.08)'},
          {transform: 'translateY(0) scale(1)', filter: 'brightness(1)'},
        ],
        {duration: 1350, iterations: Infinity, easing: 'ease-in-out'},
      );
    }
  }, {passive: true});
}

let settleResolve;
const startupSettled = new Promise((resolve) => {
  settleResolve = resolve;
});

window.addEventListener('phoenix-startup-settled', (event) => {
  const status = event?.detail === 'error' ? 'error' : 'ready';
  mark(status === 'ready' ? 'phoenix-home-ready' : 'phoenix-startup-error');
  settleResolve(status);
}, {once: true});

async function waitForStartupSettled() {
  return Promise.race([
    startupSettled,
    new Promise((_, reject) => {
      setTimeout(
        () => reject(new Error('Phoenix StartupGate did not settle within 60s.')),
        60000,
      );
    }),
  ]);
}

async function hideLoading() {
  if (!cover || coverHidden) return;
  mark('phoenix-hide-loading-requested');
  const elapsed = performance.now() - loadingStartedAt;
  const remaining = Math.max(0, minimumJourneyDurationMs - elapsed);
  mark('phoenix-minimum-duration-wait-start');
  if (remaining > 0) {
    await new Promise((resolve) => setTimeout(resolve, remaining));
  }
  mark('phoenix-minimum-duration-wait-end');
  coverHidden = true;
  hoverAnimation?.cancel();
  cover.classList.add('phoenix-loading-hidden');
  mark('phoenix-cover-hidden');
  setTimeout(() => {
    cover.remove();
    mark('phoenix-cover-removed');
  }, 760);
}

async function startPhoenix() {
  try {
    const retiredLegacyWorker = await retireLegacyFlutterWorker();
    const reloadingAfterLegacyWorkerRetirement =
      retiredLegacyWorker && reloadAfterLegacyWorkerRetirement();

    if (!reloadingAfterLegacyWorkerRetirement) {
      mark('phoenix-flutter-loader-start');
      await _flutter.loader.load({
        onEntrypointLoaded: async (engineInitializer) => {
          mark('phoenix-entrypoint-loaded');
          mark('phoenix-engine-initialize-start');
          const appRunner = await engineInitializer.initializeEngine({
            useColorEmoji: true,
          });
          mark('phoenix-engine-initialize-end');
          mark('phoenix-app-runner-start');
          await appRunner.runApp();
          mark('phoenix-app-runner-end');
          await waitForStartupSettled();
          await hideLoading();
        },
      });
    }
  } catch (error) {
    console.error('Phoenix startup failed:', error);
    mark('phoenix-startup-bootstrap-error');
    if (cover) {
      cover.querySelector('.phoenix-loading-title').textContent =
        'Phoenix Journeys · 启动失败';
      cover.querySelector('.phoenix-loading-subtitle').textContent =
        '请刷新页面后重试';
    }
  }
}

startPhoenix();
