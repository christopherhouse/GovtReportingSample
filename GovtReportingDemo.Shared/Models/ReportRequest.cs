using System;
using Newtonsoft.Json;

namespace GovtReportingDemo.Shared.Models
{
    public class ReportRequest
    {
        public DateTime? ReportingDateRangeStart { get; set; }
        
        public DateTime? ReportingDateRangeEnd { get; set; }

        public static ReportRequest FromJson(string json)
        {
            if (string.IsNullOrWhiteSpace(json))
            {
                throw new ArgumentException(nameof(json));
            }

            return JsonConvert.DeserializeObject<ReportRequest>(json);
        }
    }
}
