$(function() {
  $("form").submit(function(e) {
    e.preventDefault();
    var requrest = $.ajax({
      type: "POST",
      url: "/item/create",
      dataType: "text",
      data: { form: $("#textarea").val() }
    });

    requrest
      .done(function(data) {
        jQuery("#result").html(data);
        $("#textarea").val("");
      })
      .fail(function(e) {
        console.log("error");
      });
  });
});

function deleteItem(id) {
  var requrest = $.ajax({
    type: "POST",
    url: "/item/delete",
    dataType: "text",
    data: { id: id }
  });

  requrest
    .done(function(data) {
      jQuery("#result").html(data);
    })
    .fail(function(e) {
      console.log("error");
    });
}
function editItem(id, text) {
  showModel();
  $("#editBtn").on("click", function() {
    var requrest = $.ajax({
      type: "POST",
      url: "/item/edit",
      dataType: "text",
      data: { id: id, text: $("#editText").val() }
    });

    requrest
      .done(function(data) {
        jQuery("#result").html(data);
        $("#modal,#modalOverlay").fadeOut("slow", function() {
          $("#modalOverlay").remove();
        });
      })
      .fail(function(e) {
        console.log("error");
      });
    $("#textarea").val("");
  });
}

function showModel() {
  $("body").append('<div id="modalOverlay" class="modal_overlay"></div>');
  modalResize();

  $("#modalOverlay,#modal").fadeIn("slow");

  $(window).resize(modalResize);
  function modalResize() {
    var w = $(window).width();
    var h = $(window).height();

    var cw = $("#modal").outerWidth();
    var ch = $("#modal").outerHeight();

    $("#modal").css({
      left: (w - cw) / 2 + "px",
      top: (h - ch) / 2 + "px"
    });
  }
}
