# 多店铺创建功能修复说明

## 问题描述
用户反馈无法注册第二个店铺，点击注册后没有存到数据库里面。

## 问题原因
在 `MerchantApplicationServlet.java` 中存在一个逻辑错误：

```java
// 检查用户是否已经是商家
if (userRoleService.hasRole(userId, 2)) {
    request.setAttribute("error", "您已经是商家，无需重复申请");
    request.getRequestDispatcher("/ProfileServlet").forward(request, response);
    return;
}
```

这个检查阻止了已经是商家的用户创建第二个店铺，因为系统认为商家不需要"重复申请"。

## 修复方案

### 1. 修改 MerchantApplicationServlet.java
- **移除阻止商家创建新店铺的检查**
- **允许商家创建多个店铺**
- **优化角色管理逻辑**

修复后的逻辑：
```java
try {
    // 创建新店铺（允许商家创建多个店铺）
    Shop shop = new Shop(shopName, userId);
    boolean success = shopService.createShop(shop);
    
    if (success) {
        // 店铺创建成功
        request.setAttribute("success", "merchant_application_success");
        request.setAttribute("shopName", shopName);
        
        // 如果用户还不是商家，数据库触发器会自动添加商家角色
        if (!userRoleService.hasRole(userId, 2)) {
            // 更新session中的角色信息
            session.setAttribute("role", 2); // 切换到商家角色
        }
        
    } else {
        request.setAttribute("error", "申请失败，店铺名称可能已被使用，请更换后重试");
    }
    
} catch (Exception e) {
    e.printStackTrace();
    request.setAttribute("error", "系统错误，请稍后重试");
}
```

### 2. 修改 profile.jsp
- **更新商家用户的界面显示**
- **允许商家创建新店铺**
- **优化用户体验**

主要改动：
1. 商家用户不再显示"无需重复申请"的提示
2. 显示"创建新店铺"的表单
3. 更新表单标题和说明文字
4. 修改按钮文字为"创建新店铺"

### 3. 优化JavaScript验证
- **根据用户角色显示不同的确认对话框**
- **区分"申请入驻"和"创建新店铺"**

```javascript
// 检查当前用户角色，显示不同的确认对话框
const userRole = <%= userRole != null ? userRole : 0 %>;
let confirmMessage;

if (userRole == 2) {
    // 已经是商家，创建新店铺
    confirmMessage = '确定要创建新店铺吗？\n店铺名称：' + shopName + '\n\n您可以在商铺管理中修改店铺名称';
} else {
    // 申请入驻商家
    confirmMessage = '确定要申请入驻商家吗？\n店铺名称：' + shopName + '\n\n申请成功后可在商铺管理中修改店铺名称';
}
```

## 修复效果

### 修复前：
- ❌ 商家用户无法创建第二个店铺
- ❌ 显示"您已经是商家，无需重复申请"错误
- ❌ 商家入驻页面对商家用户显示无用信息

### 修复后：
- ✅ 商家用户可以创建多个店铺
- ✅ 普通用户可以申请入驻并创建第一个店铺
- ✅ 界面根据用户角色显示不同内容
- ✅ 确认对话框根据场景显示不同文字
- ✅ 保持原有的数据库触发器逻辑

## 测试建议

### 测试用例1：普通用户申请入驻
1. 使用普通用户账号登录
2. 进入个人中心 -> 商家入驻
3. 输入店铺名称，提交申请
4. **预期结果**：成功创建店铺，获得商家角色

### 测试用例2：商家创建第二个店铺
1. 使用商家账号登录
2. 进入个人中心 -> 商家入驻
3. 输入新店铺名称，提交申请
4. **预期结果**：成功创建第二个店铺

### 测试用例3：验证多店铺管理
1. 商家用户创建多个店铺后
2. 进入商铺管理页面
3. **预期结果**：显示所有店铺，可以分别管理

## 数据库验证

创建多个店铺后，检查数据库：

```sql
-- 查看用户的所有店铺
SELECT * FROM shop WHERE owner_id = [用户ID];

-- 查看用户角色（应该只有一条商家角色记录）
SELECT * FROM user_role WHERE user_id = [用户ID] AND role_id = 2;
```

## 安全考虑

- ✅ 保持店铺名称唯一性验证
- ✅ 保持用户身份验证
- ✅ 保持输入参数验证
- ✅ 避免重复添加商家角色
- ✅ 保持数据库触发器的完整性

## 总结

这个修复解决了商家无法创建多个店铺的问题，同时保持了系统的安全性和完整性。现在用户可以：

1. **普通用户**：申请入驻成为商家，创建第一个店铺
2. **商家用户**：创建多个店铺，在商铺管理中统一管理
3. **所有用户**：享受一致的用户体验和安全保护