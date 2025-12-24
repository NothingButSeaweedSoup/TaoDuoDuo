<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>商品图片上传 - 淘多多</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Microsoft YaHei', Arial, sans-serif;
                    background-color: #f5f5f5;
                    color: #333;
                }

                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 20px;
                }

                .header {
                    background: white;
                    padding: 20px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .upload-section {
                    background: white;
                    padding: 30px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .upload-area {
                    border: 2px solid #ddd;
                    border-radius: 8px;
                    padding: 40px;
                    text-align: center;
                    margin-bottom: 20px;
                    transition: border-color 0.3s;
                }

                .upload-area:hover {
                    border-color: #ff6b35;
                }

                .upload-icon {
                    font-size: 48px;
                    color: #ccc;
                    margin-bottom: 15px;
                }

                .upload-text {
                    font-size: 16px;
                    color: #666;
                    margin-bottom: 15px;
                }

                .file-input {
                    display: none;
                }

                .upload-btn {
                    background: #ff6b35;
                    color: white;
                    padding: 12px 30px;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 16px;
                    transition: background-color 0.3s;
                }

                .upload-btn:hover {
                    background: #e55a2b;
                }

                .submit-btn {
                    background: #28a745;
                    color: white;
                    padding: 12px 30px;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 16px;
                    margin-left: 10px;
                }

                .submit-btn:hover {
                    background: #218838;
                }

                .preview-section {
                    background: white;
                    padding: 30px;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .preview-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                    gap: 20px;
                    margin-top: 20px;
                }

                .preview-item {
                    position: relative;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    overflow: hidden;
                }

                .preview-image {
                    width: 100%;
                    height: 200px;
                    object-fit: cover;
                }

                .preview-info {
                    padding: 10px;
                    background: #f8f9fa;
                }

                .preview-name {
                    font-size: 14px;
                    color: #333;
                    margin-bottom: 5px;
                    word-break: break-all;
                }

                .preview-size {
                    font-size: 12px;
                    color: #666;
                }

                .remove-btn {
                    position: absolute;
                    top: 5px;
                    right: 5px;
                    background: rgba(255, 0, 0, 0.8);
                    color: white;
                    border: none;
                    border-radius: 50%;
                    width: 25px;
                    height: 25px;
                    cursor: pointer;
                    font-size: 14px;
                }

                .remove-btn:hover {
                    background: rgba(255, 0, 0, 1);
                }

                .message {
                    padding: 15px;
                    border-radius: 6px;
                    margin-bottom: 20px;
                }

                .message.success {
                    background: #d4edda;
                    color: #155724;
                    border: 1px solid #c3e6cb;
                }

                .message.error {
                    background: #f8d7da;
                    color: #721c24;
                    border: 1px solid #f5c6cb;
                }

                .existing-images {
                    background: white;
                    padding: 30px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }

                .existing-item {
                    position: relative;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    overflow: hidden;
                }

                .delete-existing-btn {
                    position: absolute;
                    top: 5px;
                    right: 5px;
                    background: rgba(255, 0, 0, 0.8);
                    color: white;
                    border: none;
                    border-radius: 4px;
                    padding: 5px 10px;
                    cursor: pointer;
                    font-size: 12px;
                }

                .sort-order {
                    position: absolute;
                    top: 5px;
                    left: 5px;
                    background: rgba(0, 0, 0, 0.7);
                    color: white;
                    padding: 2px 8px;
                    border-radius: 4px;
                    font-size: 12px;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="header">
                    <h1>商品图片上传</h1>
                    <p>商品ID: ${param.productId}</p>
                </div>

                <div id="message" class="message" style="display: none;"></div>

                <!-- 现有图片 -->
                <div class="existing-images">
                    <h3>现有图片</h3>
                    <div id="existingImagesGrid" class="preview-grid">
                        <!-- 现有图片将通过JavaScript加载 -->
                    </div>
                </div>

                <!-- 上传新图片 -->
                <div class="upload-section">
                    <h3>上传新图片</h3>
                    <form id="uploadForm" enctype="multipart/form-data">
                        <input type="hidden" name="productId" value="${param.productId}">

                        <div class="upload-area" id="uploadArea">
                            <div class="upload-icon">
                                <img src="${pageContext.request.contextPath}/icon/ImageFile.png" alt="上传图片"
                                    style="width: 48px; height: 48px;">
                            </div>
                            <div class="upload-text">点击下方按钮选择图片文件</div>
                            <button type="button" class="upload-btn"
                                onclick="document.getElementById('fileInput').click()">
                                <img src="${pageContext.request.contextPath}/icon/ImageFile.png" alt="选择"
                                    style="width: 16px; height: 16px; vertical-align: middle; margin-right: 5px;">
                                选择图片
                            </button>
                            <input type="file" id="fileInput" name="images" class="file-input" multiple accept="image/*"
                                onchange="handleFileSelect(event)">
                        </div>

                        <div style="text-align: center;">
                            <button type="submit" class="submit-btn">上传图片</button>
                        </div>
                    </form>
                </div>

                <!-- 预览区域 -->
                <div class="preview-section">
                    <h3>待上传图片预览</h3>
                    <div id="previewGrid" class="preview-grid">
                        <!-- 预览图片将通过JavaScript添加 -->
                    </div>
                </div>
            </div>

            <script>
                let selectedFiles = [];
                const productId = '${param.productId}';

                // 页面加载时获取现有图片
                document.addEventListener('DOMContentLoaded', function () {
                    loadExistingImages();
                });

                // 加载现有图片
                function loadExistingImages() {
                    fetch('productImageUpload?action=getImages&productId=' + productId)
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                displayExistingImages(data.images);
                            }
                        })
                        .catch(error => {
                            console.error('加载现有图片失败:', error);
                        });
                }

                // 显示现有图片
                function displayExistingImages(images) {
                    const grid = document.getElementById('existingImagesGrid');
                    grid.innerHTML = '';

                    if (images.length === 0) {
                        grid.innerHTML = '<p style="grid-column: 1/-1; text-align: center; color: #666;">暂无图片</p>';
                        return;
                    }

                    const contextPath = '${pageContext.request.contextPath}';
                    console.log('项目上下文路径:', contextPath);

                    images.forEach(function (image) {
                        const item = document.createElement('div');
                        item.className = 'existing-item';

                        const imageUrl = contextPath + image.imageUrl;
                        console.log('构建图片URL:', imageUrl);

                        // 创建图片元素
                        const img = document.createElement('img');
                        img.src = imageUrl;
                        img.alt = '商品图片';
                        img.className = 'preview-image';
                        img.onload = function () {
                            console.log('图片加载成功:', this.src);
                        };
                        img.onerror = function () {
                            console.error('图片加载失败:', this.src);
                            this.style.border = '2px solid red';
                            this.alt = '加载失败';
                        };

                        // 创建排序标签
                        const sortOrder = document.createElement('div');
                        sortOrder.className = 'sort-order';
                        sortOrder.textContent = image.sortOrder;

                        // 创建删除按钮
                        const deleteBtn = document.createElement('button');
                        deleteBtn.className = 'delete-existing-btn';
                        deleteBtn.textContent = '删除';
                        deleteBtn.onclick = function () {
                            deleteExistingImage(image.imageId);
                        };

                        // 创建信息区域
                        const previewInfo = document.createElement('div');
                        previewInfo.className = 'preview-info';
                        const previewName = document.createElement('div');
                        previewName.className = 'preview-name';
                        previewName.textContent = '图片 ' + image.sortOrder;
                        previewInfo.appendChild(previewName);

                        // 组装元素
                        item.appendChild(img);
                        item.appendChild(sortOrder);
                        item.appendChild(deleteBtn);
                        item.appendChild(previewInfo);

                        grid.appendChild(item);
                    });
                }

                // 删除现有图片
                function deleteExistingImage(imageId) {
                    if (!confirm('确定要删除这张图片吗？')) {
                        return;
                    }

                    fetch('productImageUpload?action=deleteImage&imageId=' + imageId)
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                showMessage('图片删除成功', 'success');
                                loadExistingImages(); // 重新加载图片列表
                            } else {
                                showMessage('删除失败: ' + data.message, 'error');
                            }
                        })
                        .catch(error => {
                            showMessage('删除失败: ' + error.message, 'error');
                        });
                }

                // 文件选择处理
                function handleFileSelect(event) {
                    const files = Array.from(event.target.files);
                    addFiles(files);
                }

                // 添加文件到选择列表
                function addFiles(files) {
                    files.forEach(file => {
                        if (file.type.startsWith('image/')) {
                            selectedFiles.push(file);
                        }
                    });
                    updatePreview();
                }

                // 更新预览
                function updatePreview() {
                    const previewGrid = document.getElementById('previewGrid');
                    previewGrid.innerHTML = '';

                    if (selectedFiles.length === 0) {
                        previewGrid.innerHTML = '<p style="grid-column: 1/-1; text-align: center; color: #666;">暂无选择的图片</p>';
                        return;
                    }

                    selectedFiles.forEach((file, index) => {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            const item = document.createElement('div');
                            item.className = 'preview-item';
                            item.innerHTML = `
                        <img src="${e.target.result}" alt="预览图片" class="preview-image">
                        <button class="remove-btn" onclick="removeFile(${index})">×</button>
                        <div class="preview-info">
                            <div class="preview-name">${file.name}</div>
                            <div class="preview-size">${formatFileSize(file.size)}</div>
                        </div>
                    `;
                            previewGrid.appendChild(item);
                        };
                        reader.readAsDataURL(file);
                    });
                }

                // 移除文件
                function removeFile(index) {
                    selectedFiles.splice(index, 1);
                    updatePreview();
                }

                // 格式化文件大小
                function formatFileSize(bytes) {
                    if (bytes === 0) return '0 Bytes';
                    const k = 1024;
                    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
                    const i = Math.floor(Math.log(bytes) / Math.log(k));
                    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
                }

                // 表单提交
                document.getElementById('uploadForm').addEventListener('submit', function (e) {
                    e.preventDefault();

                    if (selectedFiles.length === 0) {
                        showMessage('请选择要上传的图片', 'error');
                        return;
                    }

                    const formData = new FormData();
                    formData.append('productId', productId);

                    selectedFiles.forEach(file => {
                        formData.append('images', file);
                    });

                    // 显示上传中状态
                    const submitBtn = document.querySelector('.submit-btn');
                    const originalText = submitBtn.textContent;
                    submitBtn.textContent = '上传中...';
                    submitBtn.disabled = true;

                    fetch('productImageUpload', {
                        method: 'POST',
                        body: formData
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                showMessage(data.message, 'success');
                                selectedFiles = [];
                                updatePreview();
                                loadExistingImages(); // 重新加载现有图片
                                document.getElementById('fileInput').value = '';
                            } else {
                                showMessage('上传失败: ' + data.message, 'error');
                            }
                        })
                        .catch(error => {
                            showMessage('上传失败: ' + error.message, 'error');
                        })
                        .finally(() => {
                            submitBtn.textContent = originalText;
                            submitBtn.disabled = false;
                        });
                });

                // 显示消息
                function showMessage(text, type) {
                    const messageDiv = document.getElementById('message');
                    messageDiv.textContent = text;
                    messageDiv.className = 'message ' + type;
                    messageDiv.style.display = 'block';

                    setTimeout(() => {
                        messageDiv.style.display = 'none';
                    }, 5000);
                }
            </script>
        </body>

        </html>