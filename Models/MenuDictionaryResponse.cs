using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace hotel3g.Models
{
    public class MenuDictionaryResponse
    {
        public string IcoClass { get; set; }
        public string MenuName { get; set; }
        public string Link { get; set; }
        //排序
        public int Index { get; set; }
    }

    public static class MenuBarHelper
    {



        /// <summary>
        /// 菜单列表
        /// </summary>
        /// <param name="style"></param>
        /// <returns></returns>
        public static List<MenuDictionaryResponse> MenuBarList(int style, string weixinid, string quanjing, string userweixinid)
        {
            string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
            var ModuleAuthority = hotel3g.Models.DAL.AuthorityHelper.ModuleAuthority(weixinid);

            if (style == 5)
            {
                style = 0;
            }

            List<MenuDictionaryResponse> MenuDictionary = new List<MenuDictionaryResponse>();

            //主页
            MenuDictionaryResponse MenuItem = new MenuDictionaryResponse();
            List<string> IcoClass = new List<string>() { "", "ico i1", "ca-fixed-reserv", "ico i13", "ca-wrap-room" };
            if (ModuleAuthority.module_room == 1)
            {
                MenuItem.MenuName = "订房";
                MenuItem.Link = "/Hotel/Index/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 0;
                MenuDictionary.Add(MenuItem);
            }

            if (!userweixinid.Contains(wkn_shareopenid))
            {
                //订单
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i2", "ca-fixed-order", "ico i14", "ca-wrap-dingd" };
                MenuItem.MenuName = "订单";
                MenuItem.Link = "/User/Myorders/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 1;
                MenuDictionary.Add(MenuItem);
            }

            //地图
            MenuItem = new MenuDictionaryResponse();
            IcoClass = new List<string>() { "", "ico i3", "ca-fixed-map", "ico i15", "ca-wrap-plat" };
            MenuItem.MenuName = "地图";
            MenuItem.Link = "/Hotel/Map/";
            MenuItem.IcoClass = IcoClass[style];
            MenuItem.Index = 2;
            MenuDictionary.Add(MenuItem);
            if (!userweixinid.Contains(wkn_shareopenid))
            {
                if (ModuleAuthority.module_memberbasics == 1)
                {
                    //会员
                    MenuItem = new MenuDictionaryResponse();
                    IcoClass = new List<string>() { "", "ico i4", "ca-fixed-member", "ico i16", "ca-wrap-viper" };
                    MenuItem.MenuName = "会员";
                    MenuItem.Link = "/User/Index/";
                    MenuItem.IcoClass = IcoClass[style];
                    MenuItem.Index = 3;
                    MenuDictionary.Add(MenuItem);
                }

                //红包
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i5", "ca-wrap-fav", "ico i5", "ca-wrap-fav" };
                MenuItem.MenuName = "红包";
                MenuItem.Link = "/Home/CouPon/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 4;
                MenuDictionary.Add(MenuItem);
            }
            //分店
            if (ModuleAuthority.module_chain == 1)
            {
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i17", "ca-wrap-branch", "ico i17", "ca-wrap-branch" };
                MenuItem.MenuName = "分店";
                MenuItem.Link = "/Branch/index/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 5;
                MenuDictionary.Add(MenuItem);
            }

            //简介
            MenuItem = new MenuDictionaryResponse();
            IcoClass = new List<string>() { "", "ico i1", "ca-wrap-syn", "ico i1", "ca-wrap-syn" };
            MenuItem.MenuName = "简介";
            MenuItem.Link = "/Hotel/Info/";
            MenuItem.IcoClass = IcoClass[style];
            MenuItem.Index = 6;
            MenuDictionary.Add(MenuItem);

            //设施
            MenuItem = new MenuDictionaryResponse();
            IcoClass = new List<string>() { "", "ico i2", "ca-wrap-rec", "ico i2", "ca-wrap-rec" };
            MenuItem.MenuName = "设施";
            MenuItem.Link = "/Hotel/HotelService/";
            MenuItem.IcoClass = IcoClass[style];
            MenuItem.Index = 7;
            MenuDictionary.Add(MenuItem);

            if (ModuleAuthority.module_supermarket == 1)
            {
                //超市
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i12", "ca-wrap-super", "ico i12", "ca-wrap-super" };
                MenuItem.MenuName = "超市";
                MenuItem.Link = "/Supermarket/Index/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 8;
                MenuDictionary.Add(MenuItem);
            }

            if (ModuleAuthority.module_meals == 1)
            {
                //订餐
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i9", "ca-wrap-meal", "ico i9", "ca-wrap-meal" };
                MenuItem.MenuName = "订餐";
                MenuItem.Link = "/DishOrder/DishOrderIndex/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 9;
                MenuDictionary.Add(MenuItem);
            }
            if (!userweixinid.Contains(wkn_shareopenid))
            {
                if (ModuleAuthority.module_memberbasics == 1)
                {
                    //会员卡
                    MenuItem = new MenuDictionaryResponse();
                    IcoClass = new List<string>() { "", "ico i10", "ca-wrap-card", "ico i10", "ca-wrap-card" };
                    MenuItem.MenuName = "会员卡";
                    MenuItem.Link = "/MemberCard/MemberCenter/";
                    MenuItem.IcoClass = IcoClass[style];
                    MenuItem.Index = 10;
                    MenuDictionary.Add(MenuItem);
                }
                //充值
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i11", "ca-wrap-recharge", "ico i11", "ca-wrap-recharge" };
                MenuItem.MenuName = "充值";
                MenuItem.Link = "/Recharge/RechargeUser/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 11;
                MenuDictionary.Add(MenuItem);
            }
            //图片
            MenuItem = new MenuDictionaryResponse();
            IcoClass = new List<string>() { "", "ico i3", "ca-wrap-img", "ico i3", "ca-wrap-img" };
            MenuItem.MenuName = "图片";
            MenuItem.Link = "/Hotel/Images/";
            MenuItem.IcoClass = IcoClass[style];
            MenuItem.Index = 12;
            MenuDictionary.Add(MenuItem);

            //抢购
            MenuItem = new MenuDictionaryResponse();
            IcoClass = new List<string>() { "", "ico i6", "ca-wrap-redbag", "ico i6", "ca-wrap-redbag" };
            MenuItem.MenuName = "抢购";
            MenuItem.Link = "/Product/ProductList/";
            MenuItem.IcoClass = IcoClass[style];
            MenuItem.Index = 13;
            MenuDictionary.Add(MenuItem);

            //活动
            MenuItem = new MenuDictionaryResponse();
            IcoClass = new List<string>() { "", "ico i7", "ca-wrap-active", "ico i7", "ca-wrap-active" };
            MenuItem.MenuName = "活动";
            MenuItem.Link = "/Hotel/NewsinfoList/";
            MenuItem.IcoClass = IcoClass[style];
            MenuItem.Index = 14;
            MenuDictionary.Add(MenuItem);

            if (!userweixinid.Contains(wkn_shareopenid))
            {
                //抽奖
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i8", "ca-wrap-luck", "ico i8", "ca-wrap-luck" };
                MenuItem.MenuName = "抽奖";
                MenuItem.Link = "/Hotel/PrizeSports/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 15;
                MenuDictionary.Add(MenuItem);
            }
            if (!string.IsNullOrEmpty(quanjing))
            {
                //全景
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i4", "ca-wrap-view", "ico i4", "ca-wrap-view" };
                MenuItem.MenuName = "全景";
                MenuItem.Link = "/Hotel/QuanJing/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 16;
                MenuDictionary.Add(MenuItem);
            }
            if (ModuleAuthority.module_meeting == 1)
            {
                //会议厅
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i8", "ca-wrap-huiyt", "ico i8", "ca-wrap-huiyt" };
                MenuItem.MenuName = "会议厅";
                MenuItem.Link = "/Meeting/Index/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 17;
                MenuDictionary.Add(MenuItem);
            }
            return MenuDictionary.OrderBy(e => e.Index).ToList();
        }


        /// <summary>
        ///新版 菜单列表
        /// </summary>
        /// <param name="style"></param>
        /// <returns></returns>
        public static List<MenuDictionaryResponse> MenuBarListA(int style, string weixinid, string quanjing, string userweixinid)
        {
            string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
            var ModuleAuthority = hotel3g.Models.DAL.AuthorityHelper.ModuleAuthority(weixinid);
            if (style == 5)
            {
                style = 0;
            }
            List<MenuDictionaryResponse> MenuDictionary = new List<MenuDictionaryResponse>();

            //主页
            MenuDictionaryResponse MenuItem = new MenuDictionaryResponse();
            List<string> IcoClass = new List<string>() { "", "ico i1", "ca-fixed-reserv", "ico i13", "ca-wrap-room" };


            if (ModuleAuthority.module_room == 1)
            {
                MenuItem.MenuName = "订房";
                MenuItem.Link = "/HotelA/Index/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 0;
                MenuDictionary.Add(MenuItem);
            }
            if (!userweixinid.Contains(wkn_shareopenid))
            {
                //订单
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i2", "ca-fixed-order", "ico i14", "ca-wrap-dingd" };
                MenuItem.MenuName = "订单";
                MenuItem.Link = "/UserA/Myorders/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 1;
                MenuDictionary.Add(MenuItem);
            }
            //地图
            MenuItem = new MenuDictionaryResponse();
            IcoClass = new List<string>() { "", "ico i3", "ca-fixed-map", "ico i15", "ca-wrap-plat" };
            MenuItem.MenuName = "地图";
            MenuItem.Link = "/HotelA/Map/";
            MenuItem.IcoClass = IcoClass[style];
            MenuItem.Index = 2;
            MenuDictionary.Add(MenuItem);
            if (!userweixinid.Contains(wkn_shareopenid))
            {
                if (ModuleAuthority.module_memberbasics == 1)
                {
                    //会员
                    MenuItem = new MenuDictionaryResponse();
                    IcoClass = new List<string>() { "", "ico i4", "ca-fixed-member", "ico i16", "ca-wrap-viper" };
                    MenuItem.MenuName = "会员";
                    MenuItem.Link = "/UserA/Index/";
                    MenuItem.IcoClass = IcoClass[style];
                    MenuItem.Index = 3;
                    MenuDictionary.Add(MenuItem);
                }

                //红包
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i5", "ca-wrap-fav", "ico i5", "ca-wrap-fav" };
                MenuItem.MenuName = "红包";
                MenuItem.Link = "/HomeA/CouPon/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 4;
                MenuDictionary.Add(MenuItem);
            }
            //分店
            if (ModuleAuthority.module_chain == 1)
            {
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i17", "ca-wrap-branch", "ico i17", "ca-wrap-branch" };
                MenuItem.MenuName = "分店";
                MenuItem.Link = "/BranchA/Index/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 5;
                MenuDictionary.Add(MenuItem);
            }

            //简介
            MenuItem = new MenuDictionaryResponse();
            IcoClass = new List<string>() { "", "ico i1", "ca-wrap-syn", "ico i1", "ca-wrap-syn" };
            MenuItem.MenuName = "简介";
            MenuItem.Link = "/HotelA/Info/";
            MenuItem.IcoClass = IcoClass[style];
            MenuItem.Index = 6;
            MenuDictionary.Add(MenuItem);

            //设施
            MenuItem = new MenuDictionaryResponse();
            IcoClass = new List<string>() { "", "ico i2", "ca-wrap-rec", "ico i2", "ca-wrap-rec" };
            MenuItem.MenuName = "设施";
            MenuItem.Link = "/HotelA/HotelService/";
            MenuItem.IcoClass = IcoClass[style];
            MenuItem.Index = 7;
            MenuDictionary.Add(MenuItem);

            if (ModuleAuthority.module_supermarket == 1)
            {
                //超市
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i12", "ca-wrap-super", "ico i12", "ca-wrap-super" };
                MenuItem.MenuName = "超市";
                MenuItem.Link = "/SupermarketA/Index/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 8;
                MenuDictionary.Add(MenuItem);
            }

            if (ModuleAuthority.module_meals == 1)
            {
                //订餐
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i9", "ca-wrap-meal", "ico i9", "ca-wrap-meal" };
                MenuItem.MenuName = "订餐";
                MenuItem.Link = "/DishOrderA/DishOrderIndex/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 9;
                MenuDictionary.Add(MenuItem);
            }
            if (!userweixinid.Contains(wkn_shareopenid) && ModuleAuthority.module_memberbasics == 1)
            {
               
                    //会员卡
                    MenuItem = new MenuDictionaryResponse();
                    IcoClass = new List<string>() { "", "ico i10", "ca-wrap-card", "ico i10", "ca-wrap-card" };
                    MenuItem.MenuName = "会员卡";
                    MenuItem.Link = "/MemberCardA/MemberCenter/";
                    MenuItem.IcoClass = IcoClass[style];
                    MenuItem.Index = 10;
                    MenuDictionary.Add(MenuItem);
                

                //充值
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i11", "ca-wrap-recharge", "ico i11", "ca-wrap-recharge" };
                MenuItem.MenuName = "充值";
                MenuItem.Link = "/RechargeA/RechargeUser/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 11;
                MenuDictionary.Add(MenuItem);
            }
            //图片
            MenuItem = new MenuDictionaryResponse();
            IcoClass = new List<string>() { "", "ico i3", "ca-wrap-img", "ico i3", "ca-wrap-img" };
            MenuItem.MenuName = "图片";
            MenuItem.Link = "/HotelA/Info/";
            MenuItem.IcoClass = IcoClass[style];
            MenuItem.Index = 12;
            MenuDictionary.Add(MenuItem);

            //抢购
            MenuItem = new MenuDictionaryResponse();
            IcoClass = new List<string>() { "", "ico i6", "ca-wrap-redbag", "ico i6", "ca-wrap-redbag" };
            MenuItem.MenuName = "抢购";
            MenuItem.Link = "/ProductA/ProductList/";
            MenuItem.IcoClass = IcoClass[style];
            MenuItem.Index = 13;
            MenuDictionary.Add(MenuItem);

            //活动
            MenuItem = new MenuDictionaryResponse();
            IcoClass = new List<string>() { "", "ico i7", "ca-wrap-active", "ico i7", "ca-wrap-active" };
            MenuItem.MenuName = "活动";
            MenuItem.Link = "/HotelA/NewsinfoList/";
            MenuItem.IcoClass = IcoClass[style];
            MenuItem.Index = 14;
            MenuDictionary.Add(MenuItem);

            ////抽奖
            //MenuItem = new MenuDictionaryResponse();
            //IcoClass = new List<string>() { "", "ico i8", "ca-wrap-luck", "ico i8", "ca-wrap-luck" };
            //MenuItem.MenuName = "抽奖";
            //MenuItem.Link = "/HotelA/PrizeSports/";
            //MenuItem.IcoClass = IcoClass[style];
            //MenuItem.Index = 15;
            //MenuDictionary.Add(MenuItem);

            if (!string.IsNullOrEmpty(quanjing))
            {
                //全景
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i4", "ca-wrap-view", "ico i4", "ca-wrap-view" };
                MenuItem.MenuName = "全景";
                MenuItem.Link = "/HotelA/QuanJing/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 16;
                MenuDictionary.Add(MenuItem);
            }

            if (ModuleAuthority.module_meeting == 1)
            {
                //会议厅
                MenuItem = new MenuDictionaryResponse();
                IcoClass = new List<string>() { "", "ico i8", "ca-wrap-huiyt", "ico i8", "ca-wrap-huiyt" };
                MenuItem.MenuName = "会议厅";
                MenuItem.Link = "/MeetingA/Index/";
                MenuItem.IcoClass = IcoClass[style];
                MenuItem.Index = 17;
                MenuDictionary.Add(MenuItem);
            }

            return MenuDictionary.OrderBy(e => e.Index).ToList();
        }
    }
}