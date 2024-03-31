using AutoMapper;
using NutriaryRESTServices.BLL.DTOs;
using NutriaryRESTServices.Data.Models;
using NutriaryRESTServices.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NutriaryRESTServices.BLL.Profiles
{
    public class MapperProfile : Profile
    {
        public MapperProfile()
        {
            CreateMap<User, UserWithProfileDTO>();
            CreateMap<User, UserDTO>().ReverseMap();
            CreateMap<UserCreateDTO, User>().ReverseMap();
            CreateMap<UserWithProfile, UserWithProfileDTO>().ReverseMap();
            //CreateMap<DailyLogDetails, DailyLogDetailsDTO>().ReverseMap();
            CreateMap<DailyLogDetails, DailyLogDetailsDTO>()
                .ForMember(dest => dest.LogDate, opt => opt.MapFrom(src => DateOnly.FromDateTime(src.LogDate)));
            CreateMap<DailyLog, DailyLogDTO>().ReverseMap();
            CreateMap<FoodNutritionInfo, FoodNutritionInfoDTO>().ReverseMap();
            CreateMap<TotalNutritionReport, TotalNutritionReportDTO>();
            CreateMap<UserProfileWithCalorieInformation, UserProfileWithCalorieDTO>().ReverseMap();
            CreateMap<UserProfile, GetUserProfileDTO>().ReverseMap();
            CreateMap<CalorieSummary, CalorieSummaryDTO>();
            CreateMap<ChangePasswordResult, ChangePasswordResultDTO>();



        }
    }
}
