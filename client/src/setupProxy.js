const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function(app) {
  // Allow ngrok host
  app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
    res.setHeader('Access-Control-Allow-Credentials', true);
    next();
  });

  app.use(
    '/api',
    createProxyMiddleware({
      target: 'http://brian-yolo-backend:5000',
      changeOrigin: true,
      secure: false,
      headers: {
        Connection: 'keep-alive'
      }
    })
  );
};
