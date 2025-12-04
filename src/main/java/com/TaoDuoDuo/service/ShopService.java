package com.TaoDuoDuo.service;

import com.TaoDuoDuo.dao.ShopDao;
import com.TaoDuoDuo.entity.Shop;

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
}
