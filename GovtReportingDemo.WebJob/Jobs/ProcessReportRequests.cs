using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace GovtReportingDemo.WebJob.Jobs
{
    public class ProcessReportRequests
    {
        public static async Task ProcessQueueMessage([QueueTrigger("%ReportRequestQueueName%", Connection = "ReportStorageConnectionString")] string messageBody,
            ILogger logger)
        {
            logger.LogInformation($"Got this important message: {messageBody}");
            await Task.FromResult(0);
        }
    }
}
