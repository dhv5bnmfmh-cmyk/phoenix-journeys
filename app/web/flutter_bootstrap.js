{{flutter_js}}
{{flutter_build_config}}

const cover = document.getElementById('phoenix-loading');
const traveler = cover?.querySelector('.phoenix-loading__traveler') ?? null;
const loadingStartedAt = performance.now();
const minimumJourneyDurationMs = 3200;
const phoenixFlightDurationMs = 3200;
const coverExitTransitionMs = 360;
const legacyWorkerResetKey = 'phoenix-legacy-flutter-worker-reset';
let coverHidden = false;
let flightAnimation = null;
let hoverAnimation = null;
let flightSettled = traveler == null;
let resolveFlightCompletion;

const flightCompleted = new Promise((resolve) => {
  resolveFlightCompletion = resolve;
  if (flightSettled) resolve();
});

window.__phoenixStartupTiming = {
  minimumJourneyDurationMs,
  phoenixFlightDurationMs,
  coverExitTransitionMs,
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

function startTravelerHover() {
  if (
    coverHidden ||
    !traveler ||
    typeof traveler.animate !== 'function' ||
    window.matchMedia?.('(prefers-reduced-motion: reduce)').matches
  ) {
    return;
  }

  hoverAnimation?.cancel();
  hoverAnimation = traveler.animate(
    [
      {
        transform: 'translate3d(56vw, -20vh, 0) scale(.58) rotate(8deg)',
        filter: 'brightness(1.05) drop-shadow(0 0 14px rgba(255, 190, 76, .8))',
      },
      {
        transform: 'translate3d(56vw, -20.8vh, 0) scale(.59) rotate(7deg)',
        filter: 'brightness(1.1) drop-shadow(0 0 17px rgba(255, 198, 88, .86))',
      },
      {
        transform: 'translate3d(56vw, -20vh, 0) scale(.58) rotate(8deg)',
        filter: 'brightness(1.05) drop-shadow(0 0 14px rgba(255, 190, 76, .8))',
      },
    ],
    {
      duration: 1450,
      iterations: Infinity,
      easing: 'ease-in-out',
    },
  );
}

function finishPhoenixFlight() {
  if (flightSettled) return;
  flightSettled = true;
  mark('phoenix-flight-end');
  resolveFlightCompletion?.();
  startTravelerHover();
}

function startPhoenixFlight() {
  if (!traveler) return;

  traveler.classList.add('phoenix-time-traveler');
  mark('phoenix-flight-start');

  if (window.matchMedia?.('(prefers-reduced-motion: reduce)').matches) {
    finishPhoenixFlight();
    return;
  }

  if (typeof traveler.animate !== 'function') {
    const onAnimationEnd = (event) => {
      if (event.animationName !== 'phoenix-time-flight-v2') return;
      traveler.removeEventListener('animationend', onAnimationEnd);
      finishPhoenixFlight();
    };
    traveler.addEventListener('animationend', onAnimationEnd, {passive: true});
    setTimeout(finishPhoenixFlight, phoenixFlightDurationMs + 120);
    return;
  }

  traveler.style.animation = 'phoenix-wing-cycle 1.12s steps(1, end) infinite';
  flightAnimation = traveler.animate(
    [
      {
        offset: 0,
        opacity: 0,
        transform: 'translate3d(-88vw, 18vh, 0) scale(.38) rotate(-9deg)',
        filter: 'brightness(.76) drop-shadow(0 0 5px rgba(255, 125, 30, .38))',
        easing: 'cubic-bezier(.45, 0, .72, .48)',
      },
      {
        offset: .14,
        opacity: 1,
        transform: 'translate3d(-69vw, 12vh, 0) scale(.48) rotate(-7deg)',
        filter: 'brightness(.9) drop-shadow(0 0 9px rgba(255, 145, 38, .52))',
        easing: 'cubic-bezier(.28, .08, .28, 1)',
      },
      {
        offset: .38,
        opacity: 1,
        transform: 'translate3d(-36vw, 3vh, 0) scale(.67) rotate(-3deg)',
        filter: 'brightness(1.02) drop-shadow(0 0 13px rgba(255, 174, 55, .7))',
        easing: 'cubic-bezier(.22, .5, .3, 1)',
      },
      {
        offset: .62,
        opacity: 1,
        transform: 'translate3d(-5vw, -10vh, 0) scale(.98) rotate(2deg)',
        filter: 'brightness(1.2) drop-shadow(0 0 20px rgba(255, 204, 99, .92))',
        easing: 'cubic-bezier(.2, .58, .28, 1)',
      },
      {
        offset: .82,
        opacity: 1,
        transform: 'translate3d(26vw, -16vh, 0) scale(.78) rotate(6deg)',
        filter: 'brightness(1.13) drop-shadow(0 0 17px rgba(255, 187, 72, .84))',
        easing: 'cubic-bezier(.18, .6, .28, 1)',
      },
      {
        offset: .94,
        opacity: 1,
        transform: 'translate3d(47vw, -19vh, 0) scale(.63) rotate(8deg)',
        filter: 'brightness(1.08) drop-shadow(0 0 15px rgba(255, 180, 67, .8))',
        easing: 'cubic-bezier(.18, .62, .3, 1)',
      },
      {
        offset: 1,
        opacity: 1,
        transform: 'translate3d(56vw, -20vh, 0) scale(.58) rotate(8deg)',
        filter: 'brightness(1.05) drop-shadow(0 0 14px rgba(255, 190, 76, .8))',
      },
    ],
    {
      duration: phoenixFlightDurationMs,
      fill: 'both',
      easing: 'linear',
    },
  );

  flightAnimation.finished.then(finishPhoenixFlight).catch(finishPhoenixFlight);
  setTimeout(finishPhoenixFlight, phoenixFlightDurationMs + 120);
}

mark('phoenix-cover-created');
startPhoenixFlight();

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

  await Promise.all([
    remaining > 0
      ? new Promise((resolve) => setTimeout(resolve, remaining))
      : Promise.resolve(),
    flightCompleted,
  ]);

  mark('phoenix-minimum-duration-wait-end');
  coverHidden = true;
  hoverAnimation?.cancel();
  mark('phoenix-cover-exit-start');
  cover.style.transition =
    `opacity ${coverExitTransitionMs}ms cubic-bezier(.22, .61, .36, 1), ` +
    `visibility 0s linear ${coverExitTransitionMs}ms`;
  cover.classList.add('phoenix-loading--hidden');
  mark('phoenix-cover-hidden');

  requestAnimationFrame(() => {
    mark('phoenix-main-interactive');
  });

  setTimeout(() => {
    flightAnimation?.cancel();
    hoverAnimation?.cancel();
    cover.remove();
    mark('phoenix-cover-removed');
  }, coverExitTransitionMs + 80);
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
