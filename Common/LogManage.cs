using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace hotel3g.Common
{
    public class LogManage : ILog
    {   
        #region
        private class LogWrapper
        {
            public static log4net.ILog log = log4net.LogManager.GetLogger(typeof(LogManage));
        }
        #endregion

        public bool IsDebugEnabled
        {
            get { return LogWrapper.log.IsDebugEnabled; }
        }

        public bool IsErrorEnabled
        {
            get { return LogWrapper.log.IsErrorEnabled; }
        }

        public bool IsFatalEnabled
        {
            get { return LogWrapper.log.IsFatalEnabled; }
        }

        public bool IsInfoEnabled
        {
            get { return LogWrapper.log.IsInfoEnabled; }
        }

        public bool IsWarnEnabled
        {
            get { return LogWrapper.log.IsWarnEnabled; }
        }

        public void Debug(object message)
        {
            if (IsDebugEnabled)
            {
                LogWrapper.log.Debug(message);
            }
        }

        public void Debug(object message, Exception exception)
        {
            if (IsDebugEnabled)
            {
                LogWrapper.log.Debug(message, exception);
            }
        }

        public void Error(object message)
        {
            if (this.IsErrorEnabled)
            {
                LogWrapper.log.Error(message);
            }
        }

        public void Error(object message, Exception exception)
        {
            if (this.IsErrorEnabled)
            {
                LogWrapper.log.Error(message, exception);
            }
        }

        public void Info(object message)
        {
            if (this.IsInfoEnabled)
            {
                LogWrapper.log.Info(message);
            }
        }

        public void Info(object message, Exception exception)
        {
            if (this.IsInfoEnabled)
            {
                LogWrapper.log.Info(message, exception);
            }
        }

        public void Warn(object message)
        {
            if (this.IsWarnEnabled)
            {
                LogWrapper.log.Warn(message);
            }
        }

        public void Warn(object message, Exception exception)
        {
            if (this.IsWarnEnabled)
            {
                LogWrapper.log.Warn(message, exception);
            }
        }
    }

    public interface ILog
    {
        bool IsDebugEnabled { get; }

        bool IsErrorEnabled { get; }

        bool IsFatalEnabled { get; }

        bool IsInfoEnabled { get; }

        bool IsWarnEnabled { get; }

        void Debug(object message);

        void Debug(object message, Exception exception);

        void Error(object message);

        void Error(object message, Exception exception);

        void Info(object message);

        void Info(object message, Exception exception);

        void Warn(object message);

        void Warn(object message, Exception exception);
    }
}