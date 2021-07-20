using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace GovtReportingDemo.Functions.Functions
{
    public class StartReportProcessing
    {
        [FunctionName("StartReportProcessing")]
        public static void Run([QueueTrigger("reportRequests", Connection = "reportRequestStorageConnectionString")]string myQueueItem, ILogger log)
        {
            log.LogInformation($"C# Queue trigger function processed: {myQueueItem}");
        }
    }
}
