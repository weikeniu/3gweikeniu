using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace hotel3g.Common
{
    public static class DtFilles
    {
        #region DataTable转实体Model
        /// <summary>
        /// DataTable转实体Model
        /// </summary>
        /// <returns>实体类</returns>
        public static List<T> DtToModel<T>(this DataTable dt) where T : new()
        {
            List<T> model = new List<T>();
            if (dt != null && dt.Rows.Count > 0)
            {
                model = Filler.FillModel<T>(dt);
            }
            return model;
        }
        #endregion

        #region 判断DataSet,并赋值DataTable
        /// <summary>
        /// 判断DataSet,并赋值DataTable
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="ds"></param>
        /// <returns></returns>
        public static DataTable CheckDataSet(this DataSet ds)
        {
            DataTable dt = new DataTable();
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                dt = ds.Tables[0];
            }
            return dt;
        }
        #endregion
    }
    /// <summary>
    /// 将弱类型填充为强类型列表的帮助类
    /// </summary>
    public class Filler
    {
        #region Datatable转换为List
        /// <summary>
        /// Datatable转换为List
        /// </summary>
        public static List<T> FillModel<T>(DataTable dt)
        {
            List<T> result = new List<T>();

            T model = default(T);

            if (dt.Columns[0].ColumnName == "rowId")
            {
                dt.Columns.Remove("rowId");
            }

            foreach (DataRow dr in dt.Rows)
            {
                model = Activator.CreateInstance<T>();
                foreach (DataColumn dc in dr.Table.Columns)
                {
                    try
                    {
                        PropertyInfo pi = model.GetType().GetProperty(dc.ColumnName);
                        if (dr[dc.ColumnName] != DBNull.Value)
                        {
                            if (dr[dc.ColumnName].GetType().Name.Equals("MySqlDateTime"))
                            {
                                pi.SetValue(model, Convert.ToDateTime(dr[dc.ColumnName]), null);
                            }
                            else
                            {
                                if (!pi.PropertyType.IsGenericType)
                                {
                                    //非泛型
                                    pi.SetValue(model, ConvertType.ChangeType(dr[dc.ColumnName], pi.PropertyType), null);
                                }
                                else
                                {
                                    //泛型Nullable<>
                                    Type genericTypeDefinition = pi.PropertyType.GetGenericTypeDefinition();
                                    if (genericTypeDefinition == typeof(Nullable<>))
                                    {
                                        pi.SetValue(model, Convert.ChangeType(dr[dc.ColumnName], Nullable.GetUnderlyingType(pi.PropertyType)), null);
                                    }
                                }
                            }
                        }
                        else
                            pi.SetValue(model, null, null);
                    }
                    catch(Exception ex)
                    {
                        continue;
                    }

                }
                result.Add(model);
            }

            return result;
        }
        #endregion

        #region 判断受影响行数(大于0:true;等于0:false)
        /// <summary>
        /// 判断受影响行数(大于0:true;等于0:false)
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="ds"></param>
        /// <returns></returns>
        public static bool CheckRows(int rows)
        {
            if (rows > 0)
            {
                return true;
            }
            return false;
        }
        #endregion
    }

    /// <summary>
    /// 加强版changetype，支持可空类型和枚举转换
    /// </summary>
    public static class ConvertType
    {
        #region = ChangeType =
        public static object ChangeType(object obj, Type conversionType)
        {
            return ChangeType(obj, conversionType, Thread.CurrentThread.CurrentCulture);
        }
        public static object ChangeType(object obj, Type conversionType, IFormatProvider provider)
        {
            #region Nullable
            Type nullableType = Nullable.GetUnderlyingType(conversionType);
            if (nullableType != null)
            {
                if (obj == null)
                {
                    return null;
                }
                return Convert.ChangeType(obj, nullableType, provider);
            }
            #endregion
            if (typeof(System.Enum).IsAssignableFrom(conversionType))
            {
                return Enum.Parse(conversionType, obj.ToString());
            }
            return Convert.ChangeType(obj, conversionType, provider);
        }
        #endregion
    }
}
