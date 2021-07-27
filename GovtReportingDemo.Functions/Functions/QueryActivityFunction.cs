using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using GovtReportingDemo.Shared.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.DurableTask;
using Microsoft.Extensions.Logging;

namespace GovtReportingDemo.Functions.Functions
{
    public class QueryActivityFunction
    {
        private readonly ILogger<QueryActivityFunction> _logger;

        public QueryActivityFunction(ILogger<QueryActivityFunction> logger)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [FunctionName(nameof(QueryActivityFunction))]
        public async Task<List<int>> Run([ActivityTrigger] ReportRequest reportRequest)
        {
            var data = new List<int>(Enumerable.Range(0, 1000));

            await Task.CompletedTask;

            return data;
        }
    }
}
