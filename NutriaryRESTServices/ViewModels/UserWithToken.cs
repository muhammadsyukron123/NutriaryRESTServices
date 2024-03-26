namespace NutriaryRESTServices.ViewModels
{
    public class UserWithToken 
    {
        public int UserId { get; set; }
        public string Username { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Token { get; set; } = null!;
    }
}
