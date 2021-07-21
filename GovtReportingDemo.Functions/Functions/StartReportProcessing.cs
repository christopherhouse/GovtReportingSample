using System;
using GovtReportingDemo.Shared.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace GovtReportingDemo.Functions.Functions
{
    public class StartReportProcessing
    {
        private readonly ILogger<StartReportProcessing> _logger;

        public StartReportProcessing(ILogger<StartReportProcessing> logger)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [FunctionName("StartReportProcessing")]
        public void Run([QueueTrigger("%reportRequestQueueName%", Connection = "reportRequestStorageConnectionString")]string myQueueItem)
        {
            var model = ReportRequest.FromJson(myQueueItem);

            if (model != null)
            {
                _logger.LogInformation($"Successfully deserialized queue message, start date = {model.ReportingDateRangeStart}, end date = {model.ReportingDateRangeEnd}");
            }
            else
            {
                _logger.LogWarning($"Queue message could not be deserialized into type {typeof(ReportRequest)}");
            }
        }
    }
}
