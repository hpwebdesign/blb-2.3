<?php echo $header; ?><?php echo $column_left; ?>
<div id="content">

  <div class="page-header">
    <div class="container-fluid">
      <div class="pull-right">
        <button id="blb-btn-save" type="button" class="btn btn-primary">
          <i class="fa fa-save"></i> <?php echo $button_save; ?>
        </button>
        <a href="<?php echo $cancel; ?>" class="btn btn-default">
          <i class="fa fa-reply"></i> <?php echo $button_cancel; ?>
        </a>
      </div>
      <h1><?php echo $heading_title2; ?></h1>
      <ul class="breadcrumb">
        <?php foreach ($breadcrumbs as $bc): ?>
        <li><a href="<?php echo $bc['href']; ?>"><?php echo $bc['text']; ?></a></li>
        <?php endforeach; ?>
      </ul>
    </div>
  </div>

  <div class="container-fluid">

    <!-- Alert placeholder (toast) -->
    <div id="blb-toast" style="display:none;position:fixed;top:20px;right:20px;z-index:9999;min-width:280px;padding:14px 20px;border-radius:4px;color:#fff;font-size:14px;box-shadow:0 4px 16px rgba(0,0,0,.18);"></div>

    <div class="panel panel-default">
      <div class="panel-heading"><h3 class="panel-title"><i class="fa fa-image"></i> <?php echo $heading_title; ?></h3></div>
      <div class="panel-body form-horizontal">

        <ul class="nav nav-tabs" id="blb-tabs">
          <li class="active"><a href="#blb-tab-general" data-toggle="tab"><?php echo $tab_general; ?></a></li>
          <li><a href="#blb-tab-translation" data-toggle="tab"><?php echo $tab_translation; ?></a></li>
        </ul>

        <div class="tab-content" style="padding-top:20px;">

          <!-- ================================================================
               TAB: GENERAL
               ================================================================ -->
          <div class="tab-pane active" id="blb-tab-general">

            <!-- Status -->
            <div class="form-group">
              <label class="col-sm-2 control-label"><?php echo $entry_status; ?></label>
              <div class="col-sm-10">
                <input type="checkbox" name="blookbook_status" id="input-status" data-control="checkbox" value="1" data-off-label="<?php echo $text_disabled; ?>" data-on-label="<?php echo $text_enabled; ?>" <?php if ($blookbook_status) { ?>checked="checked"<?php } ?>/>
               
              </div>
            </div>

            <!-- Button URL -->
            <div class="form-group">
              <label class="col-sm-2 control-label"><?php echo $entry_btn_url; ?>
                <span class="help-block" style="font-weight:normal;font-size:11px;"><?php echo $help_btn_url; ?></span>
              </label>
              <div class="col-sm-10">
                <input type="text" name="blookbook_btn_url" value="<?php echo htmlspecialchars($blookbook_btn_url); ?>" class="form-control" placeholder="/shop">
              </div>
            </div>

            <hr>

            <!-- Image upload -->
            <div class="form-group">
              <label class="col-sm-2 control-label"><?php echo $entry_image; ?>
                <span class="help-block" style="font-weight:normal;font-size:11px;"><?php echo $help_image; ?></span>
              </label>
              <div class="col-sm-10">
                <a href="" id="blb-thumb-image" data-toggle="image" class="img-thumbnail" style="display:inline-block;max-width:120px;">
                  <img id="blb-preview-small"
                       src="<?php echo $blookbook_thumb ? $blookbook_thumb : $placeholder; ?>"
                       data-placeholder="<?php echo $placeholder; ?>"
                       style="max-width:120px;height:auto;">
                </a>
                <input type="hidden" name="blookbook_image" id="blb-input-image" value="<?php echo htmlspecialchars($blookbook_image); ?>">
              </div>
            </div>

            <!-- Hotspot canvas -->
            <div class="form-group">
              <label class="col-sm-2 control-label"><?php echo $entry_hotspots; ?>
                <span class="help-block" style="font-weight:normal;font-size:11px;"><?php echo $help_hotspots; ?></span>
              </label>
              <div class="col-sm-10">

                <!-- Canvas wrapper -->
                <div id="blb-canvas-wrap" style="position:relative;display:inline-block;max-width:100%; max-width: 800px; cursor:crosshair;user-select:none;border:1px solid #ddd;border-radius:2px;<?php echo !$blookbook_thumb ? 'display:none!important;' : ''; ?>">
                  <img id="blb-canvas-img"
                       src="<?php echo $blookbook_thumb_hotspot ? $blookbook_thumb_hotspot : $placeholder_hotspot; ?>"
                       style="display:block;max-width:100%;height:auto;pointer-events:none;">
                  <!-- Hotspot markers rendered here by JS -->
                </div>

                <?php if (!$blookbook_thumb): ?>
                <p class="text-muted" id="blb-no-image-hint"><i class="fa fa-info-circle"></i> <?php echo $text_no_image; ?></p>
                <?php endif; ?>

                <p class="text-muted" style="margin-top:6px;font-size:12px;" id="blb-canvas-hint">
                  <i class="fa fa-mouse-pointer"></i> <?php echo $text_hotspot_hint; ?>
                </p>
                <p id="blb-max-notice" class="text-warning" style="display:none;font-size:12px;">
                  <i class="fa fa-exclamation-triangle"></i> <?php echo $text_hotspot_max; ?>
                </p>

                <!-- Hotspot table -->
                <table class="table table-bordered table-hover" id="blb-hotspot-table" style="margin-top:14px;<?php echo empty($blookbook_hotspots) ? 'display:none;' : ''; ?>">
                  <thead>
                    <tr>
                      <th width="30"><?php echo $text_hotspot_num; ?></th>
                      <th width="120"><?php echo $text_hotspot_pos; ?></th>
                      <th><?php echo $text_hotspot_product; ?></th>
                      <th width="60"><?php echo $text_hotspot_delete; ?></th>
                    </tr>
                  </thead>
                  <tbody id="blb-hotspot-rows">
                    <?php foreach ($blookbook_hotspots as $i => $hs): ?>
                    <tr id="blb-row-<?php echo $i; ?>" data-index="<?php echo $i; ?>">
                      <td><?php echo $i + 1; ?></td>
                      <td>
                        <input type="hidden" name="blookbook_hotspots[<?php echo $i; ?>][x]" value="<?php echo $hs['x']; ?>" class="blb-hs-x">
                        <input type="hidden" name="blookbook_hotspots[<?php echo $i; ?>][y]" value="<?php echo $hs['y']; ?>" class="blb-hs-y">
                        <span class="blb-pos-label"><?php echo $hs['x']; ?>%, <?php echo $hs['y']; ?>%</span>
                      </td>
                      <td>
                        <div style="display:flex;gap:6px;align-items:center;">
                          <input type="text" class="form-control blb-product-search" placeholder="<?php echo $text_search_product; ?>" value="<?php echo htmlspecialchars($hs['product_name']); ?>" autocomplete="off" style="flex:1;">
                          <input type="hidden" name="blookbook_hotspots[<?php echo $i; ?>][product_id]" class="blb-product-id" value="<?php echo (int)$hs['product_id']; ?>">
                        </div>
                        <ul class="dropdown-menu blb-ac-dropdown" style="display:none;position:absolute;z-index:9999;"></ul>
                      </td>
                      <td>
                        <button type="button" class="btn btn-danger btn-sm blb-delete-row" data-index="<?php echo $i; ?>">
                          <i class="fa fa-times"></i>
                        </button>
                      </td>
                    </tr>
                    <?php endforeach; ?>
                  </tbody>
                </table>

              </div><!-- /.col-sm-10 -->
            </div><!-- /.form-group -->

          </div><!-- /#blb-tab-general -->

          <!-- ================================================================
               TAB: TRANSLATION
               ================================================================ -->
          <div class="tab-pane" id="blb-tab-translation">

            <!-- Language tabs (OpenCart standard style) -->
            <ul class="nav nav-tabs" id="language">
              <?php foreach ($languages as $language): ?>
              <li><a href="#language<?php echo $language['language_id']; ?>" data-toggle="tab"><img src="language/<?php echo $language['code']; ?>/<?php echo $language['code']; ?>.png" title="<?php echo $language['name']; ?>" /> <?php echo $language['name']; ?></a></li>
              <?php endforeach; ?>
            </ul>

            <div class="tab-content" style="padding-top:16px;">
              <?php $is_first_lang = true; foreach ($languages as $language): ?>
              <?php $lid = $language['language_id']; $lang = $language; ?>
              <div class="tab-pane" id="language<?php echo $lid; ?>">

                <!-- Kicker -->
                <div class="form-group">
                  <label class="col-sm-2 control-label"><?php echo $entry_kicker; ?>
                    <span class="help-block" style="font-weight:normal;font-size:11px;"><?php echo $help_kicker; ?></span>
                  </label>
                  <div class="col-sm-10">
                    <input type="text" name="blookbook_kicker[<?php echo $lid; ?>]"
                           value="<?php echo htmlspecialchars(isset($blookbook_kicker[$lid]) ? $blookbook_kicker[$lid] : ''); ?>"
                           class="form-control" placeholder="Shop the Look">
                  </div>
                </div>

                <!-- Title -->
                <div class="form-group">
                  <label class="col-sm-2 control-label"><?php echo $entry_title; ?>
                    <span class="help-block" style="font-weight:normal;font-size:11px;"><?php echo htmlspecialchars($help_title); ?></span>
                  </label>
                  <div class="col-sm-10">
                    <input type="text" name="blookbook_title[<?php echo $lid; ?>]"
                           value="<?php echo htmlspecialchars(isset($blookbook_title[$lid]) ? $blookbook_title[$lid] : ''); ?>"
                           class="form-control" placeholder="The Complete &lt;strong&gt;Kitchen Setup.&lt;/strong&gt;">
                  </div>
                </div>

                <!-- Subtitle -->
                <div class="form-group">
                  <label class="col-sm-2 control-label"><?php echo $entry_subtitle; ?>
                    <span class="help-block" style="font-weight:normal;font-size:11px;"><?php echo $help_subtitle; ?></span>
                  </label>
                  <div class="col-sm-10">
                    <textarea name="blookbook_subtitle[<?php echo $lid; ?>]" rows="3" class="form-control"><?php echo htmlspecialchars(isset($blookbook_subtitle[$lid]) ? $blookbook_subtitle[$lid] : ''); ?></textarea>
                  </div>
                </div>

                <!-- Button Label -->
                <div class="form-group">
                  <label class="col-sm-2 control-label"><?php echo $entry_btn_label; ?>
                    <span class="help-block" style="font-weight:normal;font-size:11px;"><?php echo $help_btn_label; ?></span>
                  </label>
                  <div class="col-sm-10">
                    <input type="text" name="blookbook_btn_label[<?php echo $lid; ?>]"
                           value="<?php echo htmlspecialchars(isset($blookbook_btn_label[$lid]) ? $blookbook_btn_label[$lid] : ''); ?>"
                           class="form-control" placeholder="Shop the Collection">
                  </div>
                </div>

                <hr>

                <!-- Points -->
                <div class="form-group">
                  <label class="col-sm-2 control-label"><?php echo $entry_points; ?>
                    <span class="help-block" style="font-weight:normal;font-size:11px;"><?php echo $help_points; ?></span>
                  </label>
                  <div class="col-sm-10">
                    <div id="blb-points-wrap-<?php echo $lid; ?>">
                      <?php
                      $pts = isset($blookbook_points[$lid]) ? $blookbook_points[$lid] : array();
                      foreach ($pts as $pi => $pt):
                      ?>
                      <div class="blb-point-row panel panel-default" data-index="<?php echo $pi; ?>" style="padding:10px 14px;margin-bottom:8px;">
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
                          <strong style="font-size:12px;"><?php echo $entry_points; ?> <?php echo $pi + 1; ?></strong>
                          <button type="button" class="btn btn-danger btn-xs blb-del-point" data-index="<?php echo $pi; ?>">
                            <i class="fa fa-times"></i>
                          </button>
                        </div>
                        <div class="form-group" style="margin-bottom:6px;">
                          <label class="col-xs-2 control-label" style="font-size:12px;"><?php echo $entry_point_title; ?></label>
                          <div class="col-xs-10">
                            <input type="text"
                                   name="blookbook_points[<?php echo $lid; ?>][<?php echo $pi; ?>][title]"
                                   value="<?php echo htmlspecialchars($pt['title']); ?>"
                                   class="form-control input-sm">
                          </div>
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                          <label class="col-xs-2 control-label" style="font-size:12px;"><?php echo $entry_point_desc; ?></label>
                          <div class="col-xs-10">
                            <input type="text"
                                   name="blookbook_points[<?php echo $lid; ?>][<?php echo $pi; ?>][desc]"
                                   value="<?php echo htmlspecialchars($pt['desc']); ?>"
                                   class="form-control input-sm">
                          </div>
                        </div>
                      </div>
                      <?php endforeach; ?>
                    </div>
                    <!-- /points-wrap -->

                    <?php if ($is_first_lang): ?>
                    <button type="button" id="blb-add-point" class="btn btn-default btn-sm" style="margin-top:4px;">
                      <i class="fa fa-plus"></i> <?php echo $button_add_point; ?>
                    </button>
                    <?php else: ?>
                    <!-- Points for non-first languages are synced via JS; show count only -->
                    <p class="text-muted" style="font-size:12px;margin-top:4px;">
                      <i class="fa fa-info-circle"></i> Points are synced with the first language tab. Switch back to add or remove points.
                    </p>
                    <?php endif; ?>

                  </div><!-- /.col-sm-10 -->
                </div><!-- /.form-group points -->

              </div><!-- /#language{lid} -->
              <?php $is_first_lang = false; endforeach; ?>
            </div><!-- /.tab-content (lang) -->

          </div><!-- /#blb-tab-translation -->

        </div><!-- /.tab-content (main) -->
      </div><!-- /.panel-body -->
    </div><!-- /.panel -->

  </div><!-- /.container-fluid -->
</div><!-- /#content -->

<!-- ============================================================
     ADMIN JS — Blookbook
     ============================================================ -->
<script type="text/javascript"><!--
$('#language a:first').tab('show');
$('#blb-tabs a:first').tab('show');
//--></script>

<script>
(function ($) {
  "use strict";
  if ($.fn.checkboxpicker) {
    $('[data-control=checkbox]').checkboxpicker({onClass: 'btn-info'});
  }
  $('.btn-group .btn').addClass('btn-sm');
  /* ── Config ───────────────────────────────────────────────── */
  var MAX_HOTSPOTS   = 5;
  var ACTION_SAVE    = "<?php echo $action_save; ?>";
  var ACTION_SEARCH  = "<?php echo $action_search_product; ?>";
  var LANG_IDS       = [<?php echo implode(',', array_column($languages, 'language_id')); ?>];
  var TEXT_SEARCH    = "<?php echo $text_search_product; ?>";

  /* ── State ────────────────────────────────────────────────── */
  var hotspotCount   = <?php echo count($blookbook_hotspots); ?>;
  var pointCount     = <?php echo !empty($blookbook_points) ? max(array_map('count', $blookbook_points)) : 0; ?>;
  /* Each language's points wrap element keyed by language_id */

  /* ── Toast ────────────────────────────────────────────────── */
  function showToast(msg, ok) {
    var $t = $("#blb-toast");
    $t.css("background", ok ? "#2e7d32" : "#c62828").text(msg).fadeIn(200);
    setTimeout(function () { $t.fadeOut(300); }, 3200);
  }

  /* ── AJAX Save ────────────────────────────────────────────── */
  $("#blb-btn-save").on("click", function () {
    var $btn = $(this).prop("disabled", true);

    // Kumpulkan semua field sebagai array [{name,value}]
    // $.param() akan encode bracket-notation dengan benar
    // sehingga PHP bisa membacanya via $this->request->post
    var fields = [];
    $("#content input, #content select, #content textarea").each(function () {
      var name = $(this).attr("name");
      if (!name) return;
      fields.push({ name: name, value: $(this).val() });
    });

    $.ajax({
      url:      ACTION_SAVE,
      type:     "POST",
      data:     $.param(fields),
      dataType: "json",
      success: function (d) {
        $btn.prop("disabled", false);
        if (d.success) {
          showToast(d.success, true);
        } else {
          showToast(d.error || "Save failed.", false);
        }
      },
      error: function () {
        $btn.prop("disabled", false);
        showToast("Network error.", false);
      }
    });
  });

  /* ── Image Manager callback → update canvas ──────────────── */
  // OC 2.3 image manager fires a custom event or uses upload callback
  // We watch for changes to the hidden image input
  var $imageInput = $("#blb-input-image");
  var _prevImage  = $imageInput.val();

  setInterval(function () {
    var cur = $imageInput.val();
    if (cur !== _prevImage) {
      _prevImage = cur;
      onImageChanged(cur);
    }
  }, 400);

  function onImageChanged(path) {
    if (!path) return;
    // OC thumb: we reload via the small preview already updated by image manager
    var newSrc = $("#blb-preview-small").attr("src");

  var originalSrc = newSrc
  .replace('/image/cache/', '/image/')
  .replace(/-\d+x\d+(\.[a-z]+)$/, '$1');

    $("#blb-canvas-img").attr("src", originalSrc);

    $("#blb-canvas-wrap").show();
    $("#blb-no-image-hint").hide();
  }

  /* ── Hotspot: render saved markers on page load ──────────── */
  (function renderSavedHotspots() {
    $("#blb-hotspot-rows tr").each(function () {
      var $tr  = $(this);
      var idx  = parseInt($tr.data("index"));
      var x    = $tr.find(".blb-hs-x").val();
      var y    = $tr.find(".blb-hs-y").val();
      if (x === undefined || y === undefined) return;
      var $marker = $('<span>')
        .addClass("blb-marker")
        .css({ position: "absolute", left: x + "%", top: y + "%",
               transform: "translate(-50%,-50%)",
               width: "26px", height: "26px", borderRadius: "50%",
               background: "#992a24", color: "#fff", fontSize: "12px",
               fontWeight: "700", display: "flex",
               alignItems: "center", justifyContent: "center",
               cursor: "default", userSelect: "none",
               boxShadow: "0 2px 8px rgba(0,0,0,.35)", zIndex: "9",
               lineHeight: "1" })
        .attr("data-index", idx)
        .text(idx + 1);
      $("#blb-canvas-wrap").append($marker);
    });
  })();

  /* ── Hotspot: click to place ──────────────────────────────── */
  $("#blb-canvas-wrap").on("click", function (e) {
    if (!$imageInput.val()) {
      showToast("<?php echo $text_no_image; ?>", false);
      return;
    }
    if (hotspotCount >= MAX_HOTSPOTS) {
      $("#blb-max-notice").show();
      return;
    }

    var rect  = this.getBoundingClientRect();
    var xPct  = ((e.clientX - rect.left) / rect.width  * 100).toFixed(2);
    var yPct  = ((e.clientY - rect.top)  / rect.height * 100).toFixed(2);

    addHotspot(xPct, yPct, 0, "", hotspotCount);
    hotspotCount++;

    if (hotspotCount >= MAX_HOTSPOTS) {
      $("#blb-max-notice").show();
    }
  });

  function addHotspot(x, y, productId, productName, index) {
    /* 1. Render marker on canvas */
    var $marker = $('<span>')
      .addClass("blb-marker")
      .css({ position: "absolute", left: x + "%", top: y + "%",
             transform: "translate(-50%,-50%)",
             width: "26px", height: "26px", borderRadius: "50%",
             background: "#992a24", color: "#fff", fontSize: "12px",
             fontWeight: "700", display: "flex",
             alignItems: "center", justifyContent: "center",
             cursor: "default", userSelect: "none",
             boxShadow: "0 2px 8px rgba(0,0,0,.35)", zIndex: "9",
             lineHeight: "1" })
      .attr("data-index", index)
      .text(index + 1);
    $("#blb-canvas-wrap").append($marker);

    /* 2. Add row to table */
    var row = '<tr id="blb-row-' + index + '" data-index="' + index + '">'
      + '<td>' + (index + 1) + '</td>'
      + '<td>'
      +   '<input type="hidden" name="blookbook_hotspots[' + index + '][x]" value="' + x + '" class="blb-hs-x">'
      +   '<input type="hidden" name="blookbook_hotspots[' + index + '][y]" value="' + y + '" class="blb-hs-y">'
      +   '<span class="blb-pos-label">' + x + '%, ' + y + '%</span>'
      + '</td>'
      + '<td style="position:relative;">'
      +   '<div style="display:flex;gap:6px;align-items:center;">'
      +     '<input type="text" class="form-control blb-product-search" placeholder="' + TEXT_SEARCH + '" value="' + escHtml(productName) + '" autocomplete="off" style="flex:1;">'
      +     '<input type="hidden" name="blookbook_hotspots[' + index + '][product_id]" class="blb-product-id" value="' + parseInt(productId || 0) + '">'
      +   '</div>'
      +   '<ul class="dropdown-menu blb-ac-dropdown" style="display:none;position:absolute;z-index:9999;min-width:280px;"></ul>'
      + '</td>'
      + '<td>'
      +   '<button type="button" class="btn btn-danger btn-sm blb-delete-row" data-index="' + index + '">'
      +     '<i class="fa fa-times"></i>'
      +   '</button>'
      + '</td>'
      + '</tr>';

    $("#blb-hotspot-rows").append(row);
    $("#blb-hotspot-table").show();
  }

  /* ── Hotspot: delete row ──────────────────────────────────── */
  $(document).on("click", ".blb-delete-row", function () {
    var idx = $(this).data("index");
    $("#blb-row-" + idx).remove();
    $(".blb-marker[data-index='" + idx + "']").remove();
    hotspotCount--;
    if (hotspotCount < MAX_HOTSPOTS) $("#blb-max-notice").hide();
    if (hotspotCount === 0) $("#blb-hotspot-table").hide();
    /* Re-number remaining markers */
    renumberHotspots();
  });

  function renumberHotspots() {
    var newIndex = 0;
    $("#blb-hotspot-rows tr").each(function () {
      var $tr  = $(this);
      var old  = $tr.data("index");
      $tr.attr("id", "blb-row-" + newIndex).attr("data-index", newIndex);
      $tr.find("td:first-child").text(newIndex + 1);
      $tr.find(".blb-hs-x").attr("name", "blookbook_hotspots[" + newIndex + "][x]");
      $tr.find(".blb-hs-y").attr("name", "blookbook_hotspots[" + newIndex + "][y]");
      $tr.find(".blb-product-id").attr("name", "blookbook_hotspots[" + newIndex + "][product_id]");
      $tr.find(".blb-delete-row").attr("data-index", newIndex);
      newIndex++;
    });
    /* Re-number markers on canvas */
    newIndex = 0;
    $(".blb-marker").each(function () {
      $(this).attr("data-index", newIndex).text(newIndex + 1);
      newIndex++;
    });
    hotspotCount = newIndex;
  }

  /* ── Product Autocomplete ─────────────────────────────────── */
  var acTimer = null;

  $(document).on("focus keyup", ".blb-product-search", function (e) {
    var $input    = $(this);
    var $wrap     = $input.closest("td");
    var $dropdown = $wrap.find(".blb-ac-dropdown");
    var keyword   = $input.val().trim();

    clearTimeout(acTimer);
    acTimer = setTimeout(function () {
      $.ajax({
        url: ACTION_SEARCH,
        type: "GET",
        data: { keyword: keyword },
        dataType: "json",
        success: function (data) {
          $dropdown.empty();
          if (!data.length) { $dropdown.hide(); return; }
          $.each(data, function (i, p) {
            var $li = $('<li>').css({ padding: "6px 10px", cursor: "pointer", display: "flex", gap: "8px", alignItems: "center" });
            $li.append($('<img>').attr("src", p.thumb).css({ width: "32px", height: "32px", objectFit: "cover", borderRadius: "2px" }));
            $li.append($('<span>').text(p.name + " — " + p.price));
            $li.attr("data-id", p.product_id).attr("data-name", p.name);
            $dropdown.append($li);
          });
          $dropdown.show();
        }
      });
    }, e.type === "focus" ? 0 : 250);
  });

  $(document).on("click", ".blb-ac-dropdown li", function () {
    var $li       = $(this);
    var $wrap     = $li.closest("td");
    $wrap.find(".blb-product-search").val($li.data("name"));
    $wrap.find(".blb-product-id").val($li.data("id"));
    $wrap.find(".blb-ac-dropdown").hide();
  });

  $(document).on("click", function (e) {
    if (!$(e.target).closest(".blb-product-search, .blb-ac-dropdown").length) {
      $(".blb-ac-dropdown").hide();
    }
  });

  /* ── Points: Add (synced across all language tabs) ───────── */
  $("#blb-add-point").on("click", function () {
    var idx = pointCount;
    pointCount++;

    LANG_IDS.forEach(function (lid) {
      var $wrap = $("#blb-points-wrap-" + lid);
      var html  = buildPointRow(lid, idx, "", "");
      $wrap.append(html);
    });
  });

  function buildPointRow(lid, idx, title, desc) {
    return '<div class="blb-point-row panel panel-default" data-index="' + idx + '" style="padding:10px 14px;margin-bottom:8px;">'
      + '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">'
      +   '<strong style="font-size:12px;">Point ' + (idx + 1) + '</strong>'
      +   '<button type="button" class="btn btn-danger btn-xs blb-del-point" data-index="' + idx + '">'
      +     '<i class="fa fa-times"></i>'
      +   '</button>'
      + '</div>'
      + '<div class="form-group" style="margin-bottom:6px;">'
      +   '<label class="col-xs-2 control-label" style="font-size:12px;">Title</label>'
      +   '<div class="col-xs-10">'
      +     '<input type="text" name="blookbook_points[' + lid + '][' + idx + '][title]" value="' + escHtml(title) + '" class="form-control input-sm">'
      +   '</div>'
      + '</div>'
      + '<div class="form-group" style="margin-bottom:0;">'
      +   '<label class="col-xs-2 control-label" style="font-size:12px;">Desc</label>'
      +   '<div class="col-xs-10">'
      +     '<input type="text" name="blookbook_points[' + lid + '][' + idx + '][desc]" value="' + escHtml(desc) + '" class="form-control input-sm">'
      +   '</div>'
      + '</div>'
      + '</div>';
  }

  /* ── Points: Delete (synced) ──────────────────────────────── */
  $(document).on("click", ".blb-del-point", function () {
    var idx = $(this).data("index");
    LANG_IDS.forEach(function (lid) {
      $("#blb-points-wrap-" + lid + " .blb-point-row[data-index='" + idx + "']").remove();
    });
    pointCount--;
    renumberPoints();
  });

  function renumberPoints() {
    LANG_IDS.forEach(function (lid) {
      var newIdx = 0;
      $("#blb-points-wrap-" + lid + " .blb-point-row").each(function () {
        var $row = $(this);
        $row.attr("data-index", newIdx);
        $row.find("strong").text("Point " + (newIdx + 1));
        $row.find(".blb-del-point").attr("data-index", newIdx);
        $row.find("input[name*='[title]']").attr("name", "blookbook_points[" + lid + "][" + newIdx + "][title]");
        $row.find("input[name*='[desc]']").attr("name", "blookbook_points[" + lid + "][" + newIdx + "][desc]");
        newIdx++;
      });
    });
    pointCount = LANG_IDS.reduce(function (max, lid) {
      return Math.max(max, $("#blb-points-wrap-" + lid + " .blb-point-row").length);
    }, 0);
  }

  /* ── Utility ──────────────────────────────────────────────── */
  function escHtml(s) {
    return String(s || "").replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;");
  }

})(jQuery);
</script>

<?php echo $footer; ?>
