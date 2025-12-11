<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <!DOCTYPE html>
  <html lang="zh-CN">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>淘多多 - 首页</title>
    <style>
      * {
        box-sizing: border-box;
      }

      html {
        width: 100%;
        height: 100%;
      }

      body {
        width: 100%;
        min-height: 100%;
        margin: 0;
        padding: 110px 20px 40px;
        background-color: #f5f5f5;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Microsoft YaHei", sans-serif;
      }

      .main-container {
        max-width: 800px;
        margin: 0 auto;
      }

      .page-title {
        font-size: 32px;
        font-weight: 700;
        color: #262626;
        text-align: center;
        margin-bottom: 40px;
      }

      .action-cards {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 40px;
      }

      .action-card {
        background-color: #fff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        text-align: center;
        transition: all 0.3s;
        cursor: pointer;
      }

      .action-card:hover {
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
        transform: translateY(-4px);
      }

      .action-card-icon {
        font-size: 48px;
        margin-bottom: 15px;
      }

      .action-card-title {
        font-size: 18px;
        font-weight: 600;
        color: #262626;
        margin-bottom: 10px;
      }

      .action-card-desc {
        font-size: 14px;
        color: #8c8c8c;
      }

      .test-section {
        background-color: #fff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
      }

      .test-section-title {
        font-size: 20px;
        font-weight: 600;
        color: #262626;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 2px solid #e8e8e8;
      }

      .test-form {
        display: flex;
        gap: 15px;
        align-items: flex-end;
      }

      .form-group {
        flex: 1;
      }

      .form-label {
        display: block;
        font-size: 14px;
        font-weight: 500;
        color: #595959;
        margin-bottom: 8px;
      }

      .form-input {
        width: 100%;
        height: 45px;
        padding: 0 15px;
        border: 1px solid #d9d9d9;
        border-radius: 8px;
        font-size: 15px;
        transition: all 0.3s;
      }

      .form-input:focus {
        outline: none;
        border-color: #40a9ff;
        box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.1);
      }

      .form-button {
        height: 45px;
        padding: 0 30px;
        background-color: #ff6b35;
        color: #fff;
        border: none;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        white-space: nowrap;
      }

      .form-button:hover {
        background-color: #ff8c5a;
        box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
      }
    </style>
  </head>

  <body>
    <!-- 导航栏 -->
    <%@ include file="view/head.jsp" %>

      <div class="main-container">
        <h1 class="page-title">欢迎来到淘多多</h1>

        <!-- 快捷操作卡片 -->
        <div class="action-cards">
          <% Integer indexUserRole=(Integer) session.getAttribute("role"); if (indexUserRole !=null && indexUserRole==1)
            { %>
            <div class="action-card" onclick="location.href='${pageContext.request.contextPath}/CartServlet'">
              <div class="action-card-icon">🛒</div>
              <div class="action-card-title">购物车</div>
              <div class="action-card-desc">查看购物车中的商品</div>
            </div>
            <% } else { %>
              <div class="action-card" onclick="alert('只有用户身份才能使用购物车功能')">
                <div class="action-card-icon">🛒</div>
                <div class="action-card-title">购物车</div>
                <div class="action-card-desc">
                  <% if (indexUserRole==null) { %>
                    请先登录
                    <% } else { %>
                      仅用户身份可用
                      <% } %>
                </div>
              </div>
              <% } %>

                <div class="action-card" onclick="alert('订单功能开发中...')">
                  <div class="action-card-icon">📋</div>
                  <div class="action-card-title">我的订单</div>
                  <div class="action-card-desc">查看订单状态</div>
                </div>

                <div class="action-card" onclick="alert('分类功能开发中...')">
                  <div class="action-card-icon">📦</div>
                  <div class="action-card-title">商品分类</div>
                  <div class="action-card-desc">浏览商品分类</div>
                </div>
        </div>

        <!-- 测试功能区 -->
        <div class="test-section">
          <div class="test-section-title">🔧 测试功能</div>
          <form method="get" action="${pageContext.request.contextPath}/ProductDetailServlet" class="test-form">
            <div class="form-group">
              <label for="id" class="form-label">商品ID</label>
              <input type="number" id="id" name="id" class="form-input" placeholder="请输入商品ID" required>
            </div>
            <button type="submit" class="form-button">查看商品详情</button>
          </form>
        </div>
      </div>
  </body>

  </html>