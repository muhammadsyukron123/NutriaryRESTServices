using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace NutriaryRESTServices.Domain;

[Table("UserDiary")]
public partial class UserDiary
{
    [Key]
    [Column("diary_id")]
    public int DiaryId { get; set; }

    [Column("log_date", TypeName = "datetime")]
    public DateTime LogDate { get; set; }

    [Column("notes", TypeName = "text")]
    public string Notes { get; set; } = null!;

    [Column("user_id")]
    public int UserId { get; set; }

    [ForeignKey("UserId")]
    [InverseProperty("UserDiaries")]
    public virtual User User { get; set; } = null!;
}
