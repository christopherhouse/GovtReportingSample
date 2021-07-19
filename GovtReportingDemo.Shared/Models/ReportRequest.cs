using System;

namespace GovtReportingDemo.Shared.Models
{
    public class ReportRequest
    {
        public DateTime ReportingDateRangeStart { get; set; }
        
        public DateTime ReportingDateRangeEnd { get; set; }
    }
}
