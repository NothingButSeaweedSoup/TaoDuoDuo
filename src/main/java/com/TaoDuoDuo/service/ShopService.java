package com.TaoDuoDuo.service;

import com.TaoDuoDuo.dao.ShopDao;
import com.TaoDuoDuo.entity.Shop;

import java.util.List;

public class ShopService {
    private ShopDao shopDao;

    public ShopService() {
        this.shopDao = new ShopDao();
    }

    /**
     * 根据店铺ID获取店铺信息
     * @param shopId 店铺ID
     * @return Shop对象，如果未找到返回null
     */
    public Shop getShopById(int shopId) {
        return shopDao.getShopById(shopId).orElse(null);
    }

    /**
     * 创建新店铺
     * @param shop 店铺信息
     * @return 创建成功返回true，失败返回false
     */
    public boolean createShop(Shop shop) {
        if (shop == null || shop.getShop_name() == null || shop.getShop_name().trim().isEmpty()) {
            return false;
        }
        
        // 检查店铺名称是否已存在
        List<Shop> existingShops = shopDao.getShopByName(shop.getShop_name()).orElse(null);
        if (existingShops != null && !existingShops.isEmpty()) {
            // 检查是否有完全匹配的店铺名称
            for (Shop existingShop : existingShops) {
                if (existingShop.getShop_name().equals(shop.getShop_name())) {
                    return false; // 店铺名称已存在
                }
            }
        }
        
        return shopDao.addShop(shop);
    }

    /**
     * 更新店铺信息
     * @param shop 店铺信息
     * @return 更新成功返回true，失败返回false
     */
    public boolean updateShop(Shop shop) {
        if (shop == null || shop.getShop_name() == null || shop.getShop_name().trim().isEmpty()) {
            return false;
        }
        
        // 检查店铺名称是否已被其他店铺使用
        List<Shop> existingShops = shopDao.getShopByName(shop.getShop_name()).orElse(null);
        if (existingShops != null && !existingShops.isEmpty()) {
            for (Shop existingShop : existingShops) {
                // 如果找到同名店铺且不是当前店铺，则名称重复
                if (existingShop.getShop_name().equals(shop.getShop_name()) && 
                    existingShop.getShop_id() != shop.getShop_id()) {
                    return false;
                }
            }
        }
        
        return shopDao.updateShop(shop);
    }

    /**
     * 根据用户ID获取用户拥有的店铺列表
     * @param userId 用户ID
     * @return 店铺列表，如果没有返回空列表
     */
    public List<Shop> getShopsByUserId(int userId) {
        return shopDao.getShopByOwnerId(userId).orElse(null);
    }

    /**
     * 检查用户是否拥有店铺
     * @param userId 用户ID
     * @return 拥有店铺返回true，否则返回false
     */
    public boolean hasShop(int userId) {
        List<Shop> shops = getShopsByUserId(userId);
        return shops != null && !shops.isEmpty();
    }
}
