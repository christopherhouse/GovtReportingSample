using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace GovtReportingDemo.Functions.Functions
{
    public class StartReportProcessing
    {
        private readonly ILogger _logger;

        public StartReportProcessing(ILogger logger)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [FunctionName("StartReportProcessing")]
        public void Run([QueueTrigger("reportRequests", Connection = "reportRequestStorageConnectionString")]string myQueueItem)
        {
            _logger.LogInformation($"C# Queue trigger function processed: {myQueueItem}");
        }
    }
}
