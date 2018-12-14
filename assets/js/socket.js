// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import { Socket } from "phoenix";
import "./blockchain.js";

let socket = new Socket("/socket", { params: { token: window.userToken } });

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect();

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("simulation:basic", {});

var startTime = new Date();

let tx_chart_data = {
  labels: [0],
  datasets: [
    {
      label: "Transactions done",
      data: [0],
      borderWidth: 1,
      borderColor: "rgba(255, 99, 132, 1.0)",
      backgroundColor: "rgba(255, 99, 132, 0.2)"
    }
  ]
};

let tx_chart_per_block_data = {
  labels: [0],
  datasets: [
    {
      label: "Transactions/block",
      data: [0],
      borderWidth: 1,
      borderColor: "rgba(45, 96, 216, 1.0)",
      backgroundColor: "rgba(45, 96, 216, 0.2)"
    }
  ]
};

let block_chart_data = {
  labels: [0],
  datasets: [
    {
      label: "Blocks Mined",
      data: [0],
      borderWidth: 1,
      borderColor: "rgba(45, 216, 164, 1.0)",
      backgroundColor: "rgba(45, 216, 164, 0.2)"
    }
  ]
};

let blocks_per_second = {
  labels: [0],
  datasets: [
    {
      label: "Blocks Mined Per Second",
      data: [0],
      borderWidth: 1,
      borderColor: "rgba(216, 119, 45, 1.0)",
      backgroundColor: "rgba(216, 119, 45, 0.2)"
    }
  ]
};

let options = {
  scales: {
    xAxes: [
      {
        ticks: {
          min: 0,
          stepSize: 1
        }
      }
    ]
  }
};

let totalTransactions = 0;
let transactionsPerBlock = 0;
let totalBlocksMined = 0;

var ctx = document.getElementById("txChart").getContext("2d");
var blocksMinedEl = document.getElementById("blocksChart").getContext("2d");
var txChartPerBlockEl = document
  .getElementById("txChartPerBlock")
  .getContext("2d");
var blocksMinedPerSecondEl = document
  .getElementById("blocksMinedPerSecond")
  .getContext("2d");

let transactionsCompletedSpan = document.getElementById(
  "transactions-completed"
);
let blocksMinedSpan = document.getElementById("blocks-mined");
let blocksMinedPerSecondSpan = document.getElementById(
  "blocks-mined-per-second"
);
let transactionsPerSecondSpan = document.getElementById(
  "transactions-per-second"
);

let txChart = new Chart(ctx, {
  type: "line",
  data: tx_chart_data,
  options: options
});

let blocksMinedChart = new Chart(blocksMinedEl, {
  type: "line",
  data: block_chart_data,
  options: options
});

let txChartPerBlock = new Chart(txChartPerBlockEl, {
  type: "line",
  data: tx_chart_per_block_data,
  options: options
});

let blocksMinedPerSecondChart = new Chart(blocksMinedPerSecondEl, {
  type: "line",
  data: blocks_per_second,
  options: options
});

channel.on("new_tx", payload => {
  let transactions = document.getElementById("transactions");
  var li = document.createElement("li");
  totalTransactions = totalTransactions + 1;
  transactionsPerBlock = transactionsPerBlock + 1;
  addData(txChart, totalTransactions);
  addData(txChartPerBlock, transactionsPerBlock);
  $(li).addClass("list-group-item");
  li.appendChild(
    document.createTextNode(JSON.stringify(payload.payload, null, 2))
  );
  transactions.appendChild(li);
  transactions.scrollTop = transactions.scrollHeight;
});

channel.on("clear_txs", payload => {
  let transactions = document.getElementById("transactions");
  while (transactions.firstChild) {
    transactions.removeChild(transactions.firstChild);
  }
  totalBlocksMined = totalBlocksMined + 1;
  transactionsPerBlock = 0;
  addData(blocksMinedChart, totalBlocksMined);
  var timeDiff = Math.round((new Date() - startTime) / 1000); //in ms
  addData(blocksMinedPerSecondChart, totalBlocksMined / timeDiff);
  transactionsCompletedSpan.innerHTML =
    "Completed Transactions: " + totalTransactions + " | ";
  blocksMinedSpan.innerHTML = "Blocks Mined: " + totalBlocksMined + " | ";
  transactionsPerSecondSpan.innerHTML =
    "Transactions Per Second: " + totalTransactions / timeDiff + " | ";
  blocksMinedPerSecondSpan.innerHTML =
    "Blocks Mined Per Second: " + totalBlocksMined / timeDiff;
});

channel
  .join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp);
  })
  .receive("error", resp => {
    console.log("Unable to join", resp);
  });

function addData(chart, data) {
  var last = chart.data.labels[chart.data.labels.length - 1];
  chart.data.labels.push(last + 1);
  chart.data.datasets.forEach(dataset => {
    dataset.data.push(data);
  });
  chart.update();
}

export default socket;
