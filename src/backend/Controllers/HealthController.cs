using Microsoft.AspNetCore.Mvc;

namespace GlobalFinance.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class HealthController : ControllerBase
    {
        [HttpGet]
        public IActionResult Get()
        {
            return Ok(new { status = "Healthy", environment = "Azure PaaS" });
        }
    }
}
