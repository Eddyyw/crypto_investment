class CalculateInvestment {
  constructor() {
    this.form = $("#calculate-projection-form");
    this.input = $("#amount");
    this.bodyTable = $("#table-body");
    this.csvBtn = $("#print-csv-button");
    this.jsonBtn = $("#print-json-button");

    this.calculateProjection();
    this.printCsv();
    this.printJson();
  }

  calculateProjection() {
    this.form.on("submit", (event) => {
      event.preventDefault();

      $.ajax({
        url: this.form.attr("action"),
        method: this.form.attr("method"),
        dataType: "json",
        data: {
          authenticity_token: $("meta[name=csrf-token]").attr("content"),
          amount: this.input.val()
        },
        success: $.proxy((data) => {
          this.csvBtn.data("projection", data.data);
          this.bodyTable.html("");
          $.each(data.data, (_, value) => {
            this.bodyTable.append(this.newRowStructure(value))
          })
        }, this),
        error: $.proxy(() => {
          alert("Oh, ha ocurrido un error. Vuelve a intentarlo luego.")
        }, this)
      });
    })
  }

  newRowStructure (value){
    return `
            <tr>
              <td> ${ value.month_number } </td>
              <td> ${ value.btc_amount } </td>
              <td> ${ value.eth_amount } </td>
              <td> ${ value.ada_amount } </td>
            </tr>
           `
  }

  printCsv() {
    this.csvBtn.on("click", (event) => {
      event.preventDefault();

      $.ajax({
        url: "/print_projection",
        method: "POST",
        xhrFields: {
          responseType: "blob"
        },
        data: {
          authenticity_token: $("meta[name=csrf-token]").attr("content"),
          btc_data: $("#print-csv-button").data("btc-data"),
          eth_data: $("#print-csv-button").data("eth-data"),
          ada_data: $("#print-csv-button").data("ada-data"),
          projection: $("#print-csv-button").data("projection")
        },
        success: $.proxy((data) => {
          const csv_document = new Blob([data], {type: "text/csv"}),
                url = URL.createObjectURL(csv_document);

          window.open(url);
        }, this)
      });
    })
  }

  printJson() {
    this.input.on("change", () => {
      this.jsonBtn.attr("href", `/projection?amount=${$("#amount").val()}`)
    })
  }
}

new CalculateInvestment()
