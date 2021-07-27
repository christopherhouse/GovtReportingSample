using System;
using System.Threading.Tasks;
using GovtReportingDemo.Shared.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
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
        public async Task Run([QueueTrigger("%reportRequestQueueName%", Connection = "reportRequestStorageConnectionString")]string myQueueItem,
            [DurableClient] IDurableClient starter)
        {
            var model = ReportRequest.FromJson(myQueueItem);

            if (model.ReportingDateRangeStart != null && model.ReportingDateRangeEnd != null)
            {
                _logger.LogInformation($"Successfully deserialized queue message, start date = {model.ReportingDateRangeStart}, end date = {model.ReportingDateRangeEnd}");

                var instanceId = await starter.StartNewAsync("Orchestrator", model);
                
                _logger.LogInformation($"Started durable orchestration instance {instanceId}");
            }
            else
            {
                _logger.LogWarning($"Queue message could not be deserialized into type {typeof(ReportRequest)}");
            }
        }
    }
}
