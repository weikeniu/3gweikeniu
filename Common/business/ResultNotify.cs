using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using hotel3g.Models.Home;
using System.Data;

namespace WxPayAPI
{
    /// <summary>
    /// 支付结果通知回调处理类
    /// 负责接收微信支付后台发送的支付结果并对订单有效性进行验证，将验证结果反馈给微信支付后台
    /// </summary>
    public class ResultNotify:Notify
    {
        public ResultNotify(Page page):base(page){}
        public override void ProcessNotify()
        {
            WxPayData notifyData = GetNotifyData();
            if (!notifyData.IsSet("transaction_id"))
            {
                WxPayData res = new WxPayData();
                res.SetValue("return_code", "FAIL");
                res.SetValue("return_msg", "支付结果中微信订单号不存在");
                Log.Error(this.GetType().ToString(), "The Pay result is error : " + res.ToXml());
                page.Response.Write(res.ToXml());
                page.Response.End();
            }

            string transaction_id = notifyData.GetValue("transaction_id").ToString();
            string appid = notifyData.GetValue("appid").ToString();
            string mchid = notifyData.GetValue("mch_id").ToString();

            if (!QueryOrder(transaction_id, appid, mchid))
            {
                WxPayData res = new WxPayData();
                res.SetValue("return_code", "FAIL");
                res.SetValue("return_msg", "订单查询失败");
                Log.Error(this.GetType().ToString(), "Order query failure : " + res.ToXml());
                page.Response.Write(res.ToXml());
                page.Response.End();
            }
            else
            {
                /** ================out_trade_no 我们的订单号  cash_fee 支付金额分  transaction_id  微信支付单号 ========= */
                if (notifyData.GetValue("return_code").ToString() == "SUCCESS")
                {
                    if (notifyData.GetValue("result_code").ToString() == "SUCCESS")
                    {

                        if (notifyData.GetValue("out_trade_no").ToString().IndexOf("C") > -1 || notifyData.GetValue("out_trade_no").ToString().IndexOf("c") > -1)
                        {
                            string tsql = @"insert into WeiXin..wkn_payrecords(OrderNO,TradeNo,UserWeiXinID,AliPayAmount,OperationRecord,Channel,Mchid) values(@OrderNO,@TradeNo,@UserWeiXinID,@AliPayAmount,@OperationRecord,'微信支付回调',@Mchid); ";
                            int Status = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("out_trade_no").ToString()}},
                                {"TradeNo",new HotelCloud.SqlServer.DBParam{ParamValue=transaction_id}},
                                {"Mchid",new HotelCloud.SqlServer.DBParam{ParamValue=mchid}},
                                {"UserWeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("openid").ToString()}},
                                {"AliPayAmount",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("cash_fee").ToString()}},             
                                {"OperationRecord",new HotelCloud.SqlServer.DBParam{ParamValue="[微信支付]:商户号"+mchid+"," + notifyData.GetValue("openid").ToString() + "于" + DateTime.Now.ToString() + "支付" + notifyData.GetValue("cash_fee").ToString() + "分</br>"}}                            
                            });
                            if (Status > 0) {
                                WeiXin.Models.Home.RechargeCard.DoUserRechargeSuccess(notifyData.GetValue("out_trade_no").ToString());  
                            }
                        }
                        else if (notifyData.GetValue("out_trade_no").ToString().IndexOf("K") > -1 || notifyData.GetValue("out_trade_no").ToString().IndexOf("k") > -1)
                        {
                            string tsql = @"insert into WeiXin..wkn_payrecords(OrderNO,TradeNo,UserWeiXinID,AliPayAmount,OperationRecord,Channel,Mchid) values(@OrderNO,@TradeNo,@UserWeiXinID,@AliPayAmount,@OperationRecord,'微信支付回调',@Mchid); ";
                            int Status = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("out_trade_no").ToString()}},
                                {"TradeNo",new HotelCloud.SqlServer.DBParam{ParamValue=transaction_id}},
                                {"Mchid",new HotelCloud.SqlServer.DBParam{ParamValue=mchid}},
                                {"UserWeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("openid").ToString()}},
                                {"AliPayAmount",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("cash_fee").ToString()}},             
                                {"OperationRecord",new HotelCloud.SqlServer.DBParam{ParamValue="[微信支付]:商户号"+mchid+"," + notifyData.GetValue("openid").ToString() + "于" + DateTime.Now.ToString() + "支付" + notifyData.GetValue("cash_fee").ToString() + "分</br>"}}                            
                            });
                            if (Status > 0)
                            {
                                hotel3g.Models.Home.MemberCardBuyRecord.DoneOrderSuccess(notifyData.GetValue("out_trade_no").ToString());
                            }
                        }
                        else if (notifyData.GetValue("out_trade_no").ToString().IndexOf("D") > -1)
                        {
                            string tsql = @"insert into WeiXin..wkn_payrecords(OrderNO,TradeNo,UserWeiXinID,AliPayAmount,OperationRecord,Channel,Mchid) values(@OrderNO,@TradeNo,@UserWeiXinID,@AliPayAmount,@OperationRecord,'微信支付回调',@Mchid); update WeiXin..SupermarketOrder_Levi set OrderStatus=2,PayStatus=2,PayTime=getdate(),aliPayAmount=@AliPayAmount,tradeNo=@TradeNo  where  OrderId =@OrderNO;INSERT INTO  WeiXin..SupermarketOrderLog_Levi([OrderId],[Context],[LogType],[CreateUser],[CreateTime]) VALUES(@OrderNO,'订单状态流转为:已付款',1,'用户',GETDATE());";
                            int Status = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("out_trade_no").ToString()}},
                                {"TradeNo",new HotelCloud.SqlServer.DBParam{ParamValue=transaction_id}},
                                {"Mchid",new HotelCloud.SqlServer.DBParam{ParamValue=mchid}},
                                {"UserWeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("openid").ToString()}},
                                {"AliPayAmount",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("cash_fee").ToString()}},             
                                {"OperationRecord",new HotelCloud.SqlServer.DBParam{ParamValue="[微信支付]:商户号"+mchid+","+ notifyData.GetValue("openid").ToString() + "于" + DateTime.Now.ToString() + "支付" + notifyData.GetValue("cash_fee").ToString() + "分</br>"}}                            
                            });
                        }
                        else if (notifyData.GetValue("out_trade_no").ToString().IndexOf("P") > -1 || notifyData.GetValue("out_trade_no").ToString().IndexOf("p") > -1)
                        {

                            Dictionary<string, HotelCloud.SqlServer.DBParam> dic_p = new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("out_trade_no").ToString()}},
                                {"TradeNo",new HotelCloud.SqlServer.DBParam{ParamValue=transaction_id}},
                                {"Mchid",new HotelCloud.SqlServer.DBParam{ParamValue=mchid}},
                                {"UserWeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("openid").ToString()}},
                                {"AliPayAmount",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("cash_fee").ToString()}},             
                                {"OperationRecord",new HotelCloud.SqlServer.DBParam{ParamValue="[微信支付]:商户号"+mchid+","+ notifyData.GetValue("openid").ToString() + "于" + DateTime.Now.ToString() + "支付" + notifyData.GetValue("cash_fee").ToString() + "分</br>" }}                               
                            };

                            string tsql = @"insert into WeiXin..wkn_payrecords(OrderNO,TradeNo,UserWeiXinID,AliPayAmount,OperationRecord,Channel,Mchid) values(@OrderNO,@TradeNo,@UserWeiXinID,@AliPayAmount,@OperationRecord,'微信支付回调',@Mchid); ";
                            int Status = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), dic_p);

                            if (Status > 0)
                            {
                                tsql = "update WeiXin..SaleProducts_Orders set OrderStatus=3, Remark=isnull(Remark,'')+@OperationRecord,IsPay=1,PayTime=getdate()  where  OrderNo=@OrderNO  and  IsPay=0 ";
                                int p_rows = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), dic_p);
                                if (p_rows > 0)
                                {
                                    WeiXin.Models.Home.SaleProducts_Orders.DoneOrderSuccess(notifyData.GetValue("out_trade_no").ToString());
                                }
                            }
                        }
                        else if (notifyData.GetValue("out_trade_no").ToString().IndexOf("L") > -1)
                        {
                            string tsql = @"insert into WeiXin..wkn_payrecords(OrderNO,TradeNo,UserWeiXinID,AliPayAmount,OperationRecord,Channel,Mchid) values(@OrderNO,@TradeNo,@UserWeiXinID,@AliPayAmount,@OperationRecord,'微信支付回调',@Mchid); update WeiXin..T_OrderInfo set Status=9,payTime=getdate(),orderPayState=1,tradeNo=@TradeNo,aliPayAmount=@AliPayAmount,remark=isnull(remark,'')+@OperationRecord  where  orderCode=@OrderNO;";
                            int Status = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("out_trade_no").ToString()}},
                                {"TradeNo",new HotelCloud.SqlServer.DBParam{ParamValue=transaction_id}},
                                {"Mchid",new HotelCloud.SqlServer.DBParam{ParamValue=mchid}},
                                {"UserWeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("openid").ToString()}},
                                {"AliPayAmount",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("cash_fee").ToString()}},             
                                {"OperationRecord",new HotelCloud.SqlServer.DBParam{ParamValue="[微信支付]:商户号"+mchid+"," + notifyData.GetValue("openid").ToString() + "于" + DateTime.Now.ToString() + "支付" + notifyData.GetValue("cash_fee").ToString() + "分</br>"}}                            
                            });
                            hotel3g.Models.DishOrderLogic.SettingOrderXuHao(notifyData.GetValue("out_trade_no").ToString());
                        }
                        else if (notifyData.GetValue("out_trade_no").ToString().IndexOf("wx") > -1)
                        {
                            string attach =notifyData.GetValue("attach").ToString();
                            string tsql = @"update WeiXin..wkn_quickpayment set PaymentStatus='已支付' where orderno=@OrderNO and WeiXinID=@WeiXinID;insert into WeiXin..wkn_payrecords(OrderNO,TradeNo,UserWeiXinID,AliPayAmount,OperationRecord,Channel,Mchid,WeiXinID,Mhid) values(@OrderNO,@TradeNo,@UserWeiXinID,@AliPayAmount,@OperationRecord,@Channel,@Mchid,@WeiXinID,@Mhid);";
                            int Status = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("out_trade_no").ToString()}},
                                {"TradeNo",new HotelCloud.SqlServer.DBParam{ParamValue=transaction_id}},
                                {"Mchid",new HotelCloud.SqlServer.DBParam{ParamValue=mchid}},
                                {"UserWeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("openid").ToString()}},
                                {"AliPayAmount",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("cash_fee").ToString()}},    
                                {"WeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=attach.Split('|')[1].ToString().Trim()}},    
                                {"Mhid",new HotelCloud.SqlServer.DBParam{ParamValue=attach.Split('|')[0].ToString().Trim()}},
                                {"Channel",new HotelCloud.SqlServer.DBParam{ParamValue=(attach.Split('|')[2].ToString().Trim()=="0"?"收款支付回调":"押金支付回调")}},
                                {"OperationRecord",new HotelCloud.SqlServer.DBParam{ParamValue="[微信支付]:商户号"+mchid+"," + notifyData.GetValue("openid").ToString() + "于" + DateTime.Now.ToString() + "支付" + notifyData.GetValue("cash_fee").ToString() + "分</br>"}}                            
                            });

                            //异步发送微信收款成功通知 2017-10-11  16:54
                            System.Threading.Tasks.Task task = new System.Threading.Tasks.Task(() =>
                            {
                                try
                                {
                                    WxPayAPI.Log.Info("执行异步操作，异步发送微信收款成功通知", notifyData.GetValue("out_trade_no").ToString());
                                    var request = (System.Net.HttpWebRequest)System.Net.WebRequest.Create("http://www.weikeniu.com/WeixinFeatures/sendWeiXin.aspx");
                                    var postData = "action=shoukuan&orderId=" + notifyData.GetValue("out_trade_no").ToString() + "&weixinid=" + attach.Split('|')[1].ToString().Trim();
                                    var data = System.Text.Encoding.ASCII.GetBytes(postData);
                                    request.Method = "POST";
                                    request.ContentType = "application/x-www-form-urlencoded";
                                    request.ContentLength = data.Length;
                                    using (var stream = request.GetRequestStream()){stream.Write(data, 0, data.Length);}
                                    var response = (System.Net.HttpWebResponse)request.GetResponse();
                                    var responseString = new System.IO.StreamReader(response.GetResponseStream()).ReadToEnd();
                                    string result = responseString.ToString();
                                    WxPayAPI.Log.Info("执行异步操作，发送结果：", result);
                                }
                                catch (Exception ex)
                                {
                                    WxPayAPI.Log.Info("执行异步操作，bug：", notifyData.GetValue("out_trade_no").ToString() + "|" + ex.Message.ToString());
                                }
                                finally { 
                                    
                                }
                            });
                            task.Start();
                        }
                        else
                        {
                            string tsql = @"insert into WeiXin..wkn_payrecords(OrderNO,TradeNo,UserWeiXinID,AliPayAmount,OperationRecord,Channel,Mchid) values(@OrderNO,@TradeNo,@UserWeiXinID,@AliPayAmount,@OperationRecord,'微信支付回调',@Mchid); update WeiXin..HotelOrder set Remark=isnull(Remark,'')+@OperationRecord,aliPayAmount=@AliPayAmount,aliPayTime=getdate(),tradeStatus='TRADE_FINISHED',state=24,tradeNo=@TradeNo  where  OrderNO=@OrderNO;";
                            int Status = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("out_trade_no").ToString()}},
                                {"TradeNo",new HotelCloud.SqlServer.DBParam{ParamValue=transaction_id}},
                                {"Mchid",new HotelCloud.SqlServer.DBParam{ParamValue=mchid}},
                                {"UserWeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("openid").ToString()}},                                
                                {"AliPayAmount",new HotelCloud.SqlServer.DBParam{ParamValue=notifyData.GetValue("cash_fee").ToString()}},             
                                {"OperationRecord",new HotelCloud.SqlServer.DBParam{ParamValue="[微信支付]:商户号"+mchid+"," + notifyData.GetValue("openid").ToString() + "于" + DateTime.Now.ToString() + "支付" + notifyData.GetValue("cash_fee").ToString() + "分</br>"}}                            
                            });
                        }
                    }    
                }
                WxPayData res = new WxPayData();
                res.SetValue("return_code", "SUCCESS");
                res.SetValue("return_msg", "OK");
                Log.Info(this.GetType().ToString(), "order query success : " + res.ToXml());
                page.Response.Write(res.ToXml());
                page.Response.End();
            }
        }
        private bool QueryOrder(string transaction_id, string appid, string mchid)
        {
            WxPayData req = new WxPayData();
            req.SetValue("transaction_id", transaction_id);
            req.SetValue("appid", appid);
            req.SetValue("mch_id", mchid);
            WxPayData res = WxPayApi.OrderQuery(req);
            if (res.GetValue("return_code").ToString() == "SUCCESS" && res.GetValue("result_code").ToString() == "SUCCESS")
                return true;
            else
                return false;
        }
    }
}