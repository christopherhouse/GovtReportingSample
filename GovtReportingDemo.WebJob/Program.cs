using System;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace GovtReportingDemo.WebJob
{
    class Program
    {
        static void Main(string[] args)
        {
            var builder = new HostBuilder();

            builder.ConfigureWebJobs(_ =>
            {
                _.AddAzureStorageCoreServices();
                _.AddAzureStorage();
            });

            builder.ConfigureLogging((ctx, _) =>
            {
                _.AddConsole();

                var appInsightsKey = ctx.Configuration["APPINSIGHTS_INSTRUMENTATIONKEY"];

                if (!string.IsNullOrWhiteSpace(appInsightsKey))
                {
                    _.AddApplicationInsightsWebJobs(ai => ai.InstrumentationKey = appInsightsKey);
                }
            });

#if DEBUG
            builder.UseEnvironment("development");
#endif

            var host = builder.Build();

            using (host)
            {
                await host.RunAsync();
            }
        }
    }
}
