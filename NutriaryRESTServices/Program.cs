using Microsoft.EntityFrameworkCore;
using NutriaryRESTServices.BLL;
using NutriaryRESTServices.BLL.Interfaces;
using NutriaryRESTServices.Data;
using NutriaryRESTServices.Data.Interfaces;
using NutriaryRESTServices.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("MyConnectionString")),
    ServiceLifetime.Transient);

builder.Services.AddScoped<IUser, UserData>();
builder.Services.AddScoped<IUserBLL, UserBLL>();
builder.Services.AddScoped<IConsumptionLog, ConsumptionLogData>();
builder.Services.AddScoped<IConsumptionLogBLL, ConsumptionLogBLL>();
builder.Services.AddScoped<INutrition, NutritionData>();
builder.Services.AddScoped<INutritionBLL, FoodNutritionBLL>();



var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
