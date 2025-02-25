import ApexCharts from "apexcharts";

document.addEventListener("DOMContentLoaded", function () {
  var options = {
    chart: {
      type: "line",
      height: 350,
    },
    series: [
      {
        name: "Algorithm 1",
        data: [2.5, 3.1, 3.8, 4.0, 4.2, 4.8, 5.3, 5.7], // Replace with actual values
      },
      {
        name: "Algorithm 2",
        data: [2.8, 3.0, 3.5, 3.9, 4.1, 4.6, 5.0, 5.5], // Replace with actual values
      },
      {
        name: "Algorithm 3",
        data: [2.6, 3.2, 3.7, 4.1, 4.4, 4.9, 5.1, 5.6], // Replace with actual values
      },
      {
        name: "Algorithm 4",
        data: [2.9, 3.3, 3.9, 4.2, 4.5, 5.0, 5.2, 5.8], // Replace with actual values
      },
      {
        name: "Algorithm 5",
        data: [3.0, 3.4, 4.0, 4.3, 4.6, 5.1, 5.4, 5.9], // Replace with actual values
      },
    ],
    xaxis: {
      categories: ["Cloudlet 1", "Cloudlet 100", "Cloudlet 200", "Cloudlet 300", "Cloudlet 400", "Cloudlet 500", "Cloudlet 600", "Cloudlet 800"], // Adjust as needed
      title: {
        text: "Cloudlets",
      },
    },
    yaxis: {
      title: {
        text: "Execution Time (ms)",
      },
    },
    stroke: {
      curve: "smooth",
    },
  };

  var chart = new ApexCharts(document.querySelector("#chart"), options);
  chart.render();
});
