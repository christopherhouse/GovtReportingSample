using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using GovtReportingDemo.Shared.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace GovtReportingDemo.Functions.Functions
{
    public class Orchestrator
    {
        private readonly ILogger<Orchestrator> _logger;

        public Orchestrator(ILogger<Orchestrator> logger)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [FunctionName("Orchestrator")]
        public async Task RunOrchestrator(
            [OrchestrationTrigger] IDurableOrchestrationContext context)
        {
            var inputParameters = context.GetInput<ReportRequest>();
            _logger.LogInformation(
                $"Orchestrator started, start date range = {inputParameters.ReportingDateRangeStart}, end date range = {inputParameters.ReportingDateRangeEnd}");

            // TODO:
            // 1: Define Function for each query operation
            // 2: Implement functions to retrieve data from Snowflake
            //     option a:  return data to orcehstrator
            //     option b:  store data in temporary location, such as Blob storage
            // 3: Orchestrator function calls and awaits each query function
            // 4: When all query functions have completed, create Excel file
            // 5: Write Excel file to Blob storage

            // Simple example, calling the same activity function twice, passing in input parameters, operating on return values
            var data1 = await context.CallActivityAsync<List<int>>(nameof(QueryActivityFunction), inputParameters);
            var data2 = await context.CallActivityAsync<List<int>>(nameof(QueryActivityFunction), inputParameters);

            foreach (var item in data1)
            {
                _logger.LogInformation(item.ToString());
            }

            await Task.CompletedTask;
        }
    }
}