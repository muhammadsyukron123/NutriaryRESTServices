using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using NutriaryRESTServices.Domain;

namespace NutriaryRESTServices.Models;

public partial class AppDbContext : DbContext
{
    public AppDbContext()
    {
    }

    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<ActivityLevel> ActivityLevels { get; set; }


    public virtual DbSet<DailyLog> DailyLogs { get; set; }


    public virtual DbSet<FoodNutritionInfo> FoodNutritionInfos { get; set; }

    public virtual DbSet<TargetGoal> TargetGoals { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserCalorieInformation> UserCalorieInformations { get; set; }

    public virtual DbSet<UserDiary> UserDiaries { get; set; }

    public virtual DbSet<UserProfile> UserProfiles { get; set; }



    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=.\\BSISQLEXPRESS;Initial Catalog=NutriaryDatabase;Integrated Security=True;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ActivityLevel>(entity =>
        {
            entity.HasKey(e => e.ActivityId).HasName("PK__Activity__482FBD63D29234C2");
        });


        modelBuilder.Entity<DailyLog>(entity =>
        {
            entity.HasKey(e => e.LogId).HasName("PK__DailyLog__9E2397E04EDBF15D");

            entity.HasOne(d => d.Food).WithMany(p => p.DailyLogs)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__DailyLogs__food___37A5467C");

            entity.HasOne(d => d.User).WithMany(p => p.DailyLogs)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__DailyLogs__user___36B12243");
        });


        modelBuilder.Entity<TargetGoal>(entity =>
        {
            entity.HasKey(e => e.GoalId).HasName("PK__TargetGo__76679A24D4D6967A");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__Users__B9BE370FC263C3F0");

            entity.Property(e => e.Firstname).HasDefaultValue("john");
            entity.Property(e => e.Lastname).HasDefaultValue("doe");
        });

        modelBuilder.Entity<UserCalorieInformation>(entity =>
        {
            entity.HasKey(e => e.CalorieInfoId).HasName("PK__UserCalo__3D49CC5F0A704D6D");

            entity.HasOne(d => d.ActivityLevel).WithMany(p => p.UserCalorieInformations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__UserCalor__activ__31EC6D26");

            entity.HasOne(d => d.TargetGoal).WithMany(p => p.UserCalorieInformations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UserCalorieInformation_TargetGoals");

            entity.HasOne(d => d.User).WithMany(p => p.UserCalorieInformations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__UserCalor__user___30F848ED");
        });

        modelBuilder.Entity<UserDiary>(entity =>
        {
            entity.HasOne(d => d.User).WithMany(p => p.UserDiaries)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_UserDiary_Users");
        });

        modelBuilder.Entity<UserProfile>(entity =>
        {
            entity.HasKey(e => e.ProfileId).HasName("PK__UserProf__AEBB701F948C8E48");

            entity.HasOne(d => d.User).WithMany(p => p.UserProfiles)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__UserProfi__user___2A4B4B5E");
        });

        modelBuilder.Entity<UserWithProfile>().HasKey(b => b.UserId);

        modelBuilder.Entity<DailyLogDetails>().HasKey(l => l.UserId);

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
