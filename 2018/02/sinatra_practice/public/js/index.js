$(function() {
  $("#sendForm").submit(function(e) {
    e.preventDefault();
    const requrest = $.ajax({
      type: "POST",
      url: "/articles/create",
      dataType: "text",
      data: { form: $("#textarea").val(), tags: $("#tags").val() }
    });

    requrest
      .done(function(data) {
        jQuery("#result").html(data);
        $("#textarea").val("");
        $("#tags").val("");
      })
      .fail(function(e) {
        console.log("error");
      });
  });
});

function deleteItem(id) {
  const requrest = $.ajax({
    type: "POST",
    url: "/articles/delete",
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
function editItem(id) {
  showModel();
  $("#editText").val(jQuery("#" + id).text());
  $("#editTag").val(jQuery("#tag" + id).data("tag"));
  $("#editBtn").on("click", function() {
    const requrest = $.ajax({
      type: "POST",
      url: "/articles/edit",
      dataType: "text",
      data: { id: id, text: $("#editText").val(), tags: $("#editTag").val() }
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

  $("#cancelBtn").on("click", function() {
    $("#modal, #modalOverlay").fadeOut("slow", function() {
      $("#modalOverlay").remove();
    });
  });
}

function showModel() {
  $("body").append('<div id="modalOverlay" class="modal-overlay"></div>');
  modalResize();

  $("#modalOverlay,#modal").fadeIn("slow");

  $(window).resize(modalResize);
  function modalResize() {
    const w = $(window).width();
    const h = $(window).height();

    const cw = $("#modal").outerWidth();
    const ch = $("#modal").outerHeight();

    $("#modal").css({
      left: (w - cw) / 2 + "px",
      top: (h - ch) / 2 + "px"
    });
  }
}

function getPage(pageNumber) {
  event.preventDefault();
  const requrest = $.ajax({
    type: "GET",
    url: "articles",
    dataType: "text",
    data: { page: pageNumber }
  });

  requrest
    .done(function(data) {
      jQuery("#result").html(data);
    })
    .fail(function(e) {
      console.log("error");
    });
}

function searchArticle() {
  event.preventDefault();

  const requrest = $.ajax({
    type: "GET",
    url: "/search",
    dataType: "text",
    data: { searchText: $("#searchText").val() }
  });

  requrest
    .done(function(data) {
      jQuery("#result").html(data);
    })
    .fail(function(e) {
      console.log("error");
    });
}
