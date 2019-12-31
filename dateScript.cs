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
            AuthSecret = "------------",
            BasePath = "------"
        };

        public static void Main(string[] args)
        {
            DateTime startDate = new DateTime(2019, 12, 31);
            DateTime endDate = new DateTime(2020, 1, 02);

            List<DateTime> dateList = new List<DateTime>();      
            IFirebaseClient client;
            Int32 unixStartTimestamp;
            client = new FireSharp.FirebaseClient(config);

            int i = 0;
            while (startDate.AddDays(1) <= endDate)
            {
       
                startDate = startDate.AddDays(1);
               //  unixStartTimestamp = (Int32) (startDate.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;

               dateList.Add(startDate);

                client.Set("Peer2Strangers/Appointments/Confirmed", "");
                client.Set("Peer2Strangers/Appointments/Awaiting/" + dateList[i].ToString("yyyy-MM-dd"), "");
                client.Set("Peer2Strangers/Appointments/Cancelled/" + dateList[i].ToString("yyyy-MM-dd"), "");


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
