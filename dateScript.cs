using System;
using System.Collections.Generic;
using FireSharp.Config;
using FireSharp.Interfaces;
using FireSharp.Response;

//Script
namespace dateScript
{
    class
        Program
    {
        static IFirebaseConfig config = new FirebaseConfig
        {
            AuthSecret = "-----",
            BasePath = "------"
        };

        public static void Main(string[] args)
        {
            DateTime startDate = new DateTime(2019, 12, 25);
            DateTime endDate = new DateTime(2020, 12, 25);

            List<DateTime> dateList = new List<DateTime>();      
            IFirebaseClient client;
            client = new FireSharp.FirebaseClient(config);

            int i = 0;
            while (startDate.AddDays(1) <= endDate)
            {


                //Increments by 1
                startDate = startDate.AddDays(1);

                dateList.Add(startDate);
                client.Set("Appointments/" + dateList[i].ToString("ddd, MMMM d yyyy"), "");
                i++;

            }

            // Appointment result = response.ResultAs<Appointment>(); //The response will contain the data writte

        }
    }

    internal class Appointment
    {
        public List <DateTime> date { get; set; }
    }
}
