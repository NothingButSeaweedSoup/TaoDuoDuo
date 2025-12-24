<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.TaoDuoDuo.service.ProductImageService" %>
        <%@ page import="com.TaoDuoDuo.util.DualSaveTestUtil" %>
            <%@ page import="java.io.File" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <title>双重保存测试</title>
                    <meta charset="UTF-8">
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            margin: 20px;
                        }

                        .test-section {
                            margin: 20px 0;
                            padding: 15px;
                            border: 1px solid #ddd;
                        }

                        .success {
                            color: green;
                        }

                        .error {
                            color: red;
                        }

                        pre {
                            background: #f5f5f5;
                            padding: 10px;
                            overflow-x: auto;
                        }
                    </style>
                </head>

                <body>
                    <h1>双重保存功能测试</h1>

                    <% // 获取路径信息 String runtimeWebPath=application.getRealPath("/"); ProductImageService service=new
                        ProductImageService(); // 使用反射获取源码路径（因为getSourceWebPath是private方法） java.lang.reflect.Method
                        method=service.getClass().getDeclaredMethod("getSourceWebPath"); method.setAccessible(true);
                        String sourceWebPath=(String) method.invoke(service); %>

                        <div class="test-section">
                            <h2>路径信息</h2>
                            <p><strong>运行时Web路径:</strong>
                                <%= runtimeWebPath %>
                            </p>
                            <p><strong>源码Web路径:</strong>
                                <%= sourceWebPath %>
                            </p>
                        </div>

                        <div class="test-section">
                            <h2>目录结构检查</h2>
                            <% // 检查运行时目录 File runtimeImagesDir=new File(runtimeWebPath + File.separator + "images" +
                                File.separator + "productImage" ); File sourceImagesDir=new File(sourceWebPath +
                                File.separator + "images" + File.separator + "productImage" ); %>
                                <p><strong>运行时图片目录存在:</strong>
                                    <span class="<%= runtimeImagesDir.exists() ? " success" : "error" %>">
                                        <%= runtimeImagesDir.exists() %>
                                    </span>
                                </p>
                                <p><strong>源码图片目录存在:</strong>
                                    <span class="<%= sourceImagesDir.exists() ? " success" : "error" %>">
                                        <%= sourceImagesDir.exists() %>
                                    </span>
                                </p>
                        </div>

                        <% // 检查是否有测试商品的图片 String testProductId=request.getParameter("productId"); if (testProductId
                            !=null && !testProductId.trim().isEmpty()) { try { int
                            productId=Integer.parseInt(testProductId); %>
                            <div class="test-section">
                                <h2>商品 <%= productId %> 图片检查</h2>

                                <h3>运行时目录:</h3>
                                <pre><%= DualSaveTestUtil.listProductImages(runtimeWebPath, productId) %></pre>

                                <h3>源码目录:</h3>
                                <pre><%= DualSaveTestUtil.listProductImages(sourceWebPath, productId) %></pre>

                                <% // 检查具体文件 String fileName=request.getParameter("fileName"); if (fileName !=null &&
                                    !fileName.trim().isEmpty()) { %>
                                    <h3>文件 <%= fileName %> 双重保存检查:</h3>
                                    <pre><%= DualSaveTestUtil.checkDualSave(runtimeWebPath, sourceWebPath, productId, fileName) %></pre>
                                    <% } } catch (NumberFormatException e) { %>
                                        <p class="error">无效的商品ID: <%= testProductId %>
                                        </p>
                                        <% } } %>

                                            <div class="test-section">
                                                <h2>测试工具</h2>
                                                <form method="get">
                                                    <p>
                                                        <label>商品ID: </label>
                                                        <input type="number" name="productId"
                                                            value="<%= request.getParameter(" productId") !=null ?
                                                            request.getParameter("productId") : "" %>" />
                                                    </p>
                                                    <p>
                                                        <label>文件名: </label>
                                                        <input type="text" name="fileName"
                                                            value="<%= request.getParameter(" fileName") !=null ?
                                                            request.getParameter("fileName") : "" %>" placeholder="例如:
                                                        1.jpg" />
                                                    </p>
                                                    <p>
                                                        <button type="submit">检查</button>
                                                    </p>
                                                </form>
                                            </div>

                                            <div class="test-section">
                                                <h2>说明</h2>
                                                <p>此页面用于测试双重保存功能是否正常工作。</p>
                                                <ul>
                                                    <li>上传图片后，应该同时保存到运行时目录和源码目录</li>
                                                    <li>删除图片时，应该同时从两个目录中删除</li>
                                                    <li>两个目录中的文件应该完全一致</li>
                                                </ul>
                                                <p><strong>测试步骤:</strong></p>
                                                <ol>
                                                    <li>先上传一些商品图片</li>
                                                    <li>在上面输入商品ID和文件名进行检查</li>
                                                    <li>验证文件是否在两个目录中都存在且大小一致</li>
                                                </ol>
                                            </div>
                </body>

                </html>