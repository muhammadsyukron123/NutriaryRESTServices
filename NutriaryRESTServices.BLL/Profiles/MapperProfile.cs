﻿using AutoMapper;
using NutriaryRESTServices.BLL.DTOs;
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
            CreateMap<UserWithProfile, UserWithProfileDTO>().ReverseMap();
            //CreateMap<DailyLogDetails, DailyLogDetailsDTO>().ReverseMap();
            CreateMap<DailyLogDetails, DailyLogDetailsDTO>()
                .ForMember(dest => dest.LogDate, opt => opt.MapFrom(src => DateOnly.FromDateTime(src.LogDate)));
            CreateMap<DailyLog, DailyLogDTO>().ReverseMap();
            CreateMap<FoodNutritionInfo, FoodNutritionInfoDTO>().ReverseMap();



        }
    }
}