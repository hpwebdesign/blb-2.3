(function () {
  "use strict";

  function closest(el, sel) {
    while (el && el.nodeType === 1) {
      if (el.matches(sel)) return el;
      el = el.parentElement;
    }
    return null;
  }

  function setPopupNearHotspot(figure, hotspot, popup) {
    const figRect = figure.getBoundingClientRect();
    const btnRect = hotspot.getBoundingClientRect();
    const popupW  = popup.offsetWidth;
    const popupH  = popup.offsetHeight;
    const GAP     = 12;

    let left = btnRect.left - figRect.left + GAP;
    let top  = btnRect.top  - figRect.top  + GAP;

    // Flip left if hitting right viewport edge
    if (btnRect.left + popupW + GAP > window.innerWidth) {
      left = btnRect.left - figRect.left - popupW - GAP;
    }

    // Flip up if hitting bottom viewport edge
    if (btnRect.top + popupH + GAP > window.innerHeight) {
      top = btnRect.top - figRect.top - popupH - GAP;
    }

    // Clamp within figure bounds
    left = Math.max(8, Math.min(left, figRect.width  - popupW - 8));
    top  = Math.max(8, Math.min(top,  figRect.height - popupH - 8));

    popup.style.left = left + "px";
    popup.style.top  = top  + "px";
    // Override the CSS default positioning so dynamic placement takes over
    popup.style.bottom = "auto";
    popup.style.right  = "auto";
  }

  function closePopup(popup, hotspot) {
    if (!popup) return;
    popup.classList.remove("is-open");
    if (hotspot) hotspot.setAttribute("aria-expanded", "false");
  }

  function closeAll(exceptPopup) {
    document.querySelectorAll(".savvy-lookbook__popup.is-open").forEach(function (p) {
      if (exceptPopup && p === exceptPopup) return;
      p.classList.remove("is-open");
    });
    document.querySelectorAll(".savvy-lookbook__hotspot[aria-expanded='true']").forEach(function (b) {
      b.setAttribute("aria-expanded", "false");
    });
  }

  // Delegated click handler
  document.addEventListener("click", function (e) {
    var hotspot  = closest(e.target, ".savvy-lookbook__hotspot");
    var closeBtn = closest(e.target, ".savvy-lookbook__close");

    // Close button
    if (closeBtn) {
      var popup = closest(closeBtn, ".savvy-lookbook__popup");
      if (popup) popup.classList.remove("is-open");
      e.preventDefault();
      return;
    }

    // Hotspot click
    if (hotspot) {
      var figure   = closest(hotspot, ".savvy-lookbook");
      if (!figure) return;

      var popupId  = hotspot.getAttribute("aria-controls");
      var popup    = popupId
        ? figure.querySelector("#" + CSS.escape(popupId))
        : figure.querySelector(".savvy-lookbook__popup");

      if (!popup) {
        console.warn("[Blookbook] Popup not found for aria-controls:", popupId);
        return;
      }

      var isOpen = popup.classList.contains("is-open");

      // Close all other popups first
      closeAll(null);

      if (!isOpen) {
        popup.classList.add("is-open");
        hotspot.setAttribute("aria-expanded", "true");
        setPopupNearHotspot(figure, hotspot, popup);
      }

      e.preventDefault();
      e.stopPropagation();
      return;
    }

    // Outside click — close all
    if (!closest(e.target, ".savvy-lookbook")) {
      closeAll(null);
    }
  });

  // ESC closes all
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") closeAll(null);
  });

  // Reposition on resize
  window.addEventListener("resize", function () {
    document.querySelectorAll(".savvy-lookbook__popup.is-open").forEach(function (popup) {
      var figure  = closest(popup, ".savvy-lookbook");
      var popupId = popup.id;
      var hotspot = popupId
        ? document.querySelector("[aria-controls='" + popupId + "']")
        : null;
      if (figure && hotspot) setPopupNearHotspot(figure, hotspot, popup);
    });
  });

})();