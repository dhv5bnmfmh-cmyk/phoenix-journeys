{{flutter_js}}
{{flutter_build_config}}

const loading = document.getElementById('phoenix-loading');
const loadingText = document.getElementById('phoenix-loading-text');

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

(async () => {
  try {
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
