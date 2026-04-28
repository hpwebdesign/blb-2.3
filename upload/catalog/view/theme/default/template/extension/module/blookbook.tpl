<?php if ($css_url): ?>
<link rel="stylesheet" href="<?php echo $css_url; ?>">
<?php endif; ?>

<section class="savvy-split savvy-split--reverse">
  <div class="savvy-split__container">

    <!-- ── Left: Content ─────────────────────────────────────────── -->
    <div class="savvy-split__content">

      <?php if ($kicker): ?>
      <div class="savvy-split__kicker">
        <span class="savvy-split__kicker-line"></span>
        <span><?php echo htmlspecialchars($kicker); ?></span>
      </div>
      <?php endif; ?>

      <?php if ($title): ?>
      <h2 class="savvy-split__title">
        <?php echo $title; /* Allows <strong> tag — sanitised on save */ ?>
      </h2>
      <?php endif; ?>

      <?php if ($subtitle): ?>
      <p class="savvy-split__text"><?php echo htmlspecialchars($subtitle); ?></p>
      <?php endif; ?>

      <?php if (!empty($points)): ?>
      <div class="savvy-split__points">
        <?php foreach ($points as $i => $pt): ?>
        <div class="savvy-point">
          <span class="savvy-point__num"><?php echo str_pad($i + 1, 2, '0', STR_PAD_LEFT); ?></span>
          <div>
            <?php if (!empty($pt['title'])): ?>
            <h3 class="savvy-point__title"><?php echo htmlspecialchars($pt['title']); ?></h3>
            <?php endif; ?>
            <?php if (!empty($pt['desc'])): ?>
            <p class="savvy-point__desc"><?php echo htmlspecialchars($pt['desc']); ?></p>
            <?php endif; ?>
          </div>
        </div>
        <?php endforeach; ?>
      </div>
      <?php endif; ?>

      <?php if ($btn_label && $btn_url): ?>
      <a class="savvy-split__btn" href="<?php echo htmlspecialchars($btn_url); ?>">
        <?php echo htmlspecialchars($btn_label); ?>
      </a>
      <?php endif; ?>

    </div>
    <!-- ── /Left ──────────────────────────────────────────────────── -->

    <!-- ── Right: Lookbook ───────────────────────────────────────── -->
    <figure class="savvy-split__media savvy-lookbook" id="blbLookbook">
      <img src="<?php echo $image; ?>" alt="<?php echo htmlspecialchars($title); ?>" loading="lazy">

      <?php foreach ($hotspots as $i => $hs): ?>
      <?php
        // Auto-detect popup side: if hotspot is in right half → popup opens to left
        $popup_class = $hs['x'] > 50 ? ' savvy-lookbook__popup--left' : '';
        $popup_id    = 'blb-popup-' . ($i + 1);
      ?>

      <!-- Hotspot <?php echo $i + 1; ?> -->
      <button
        class="savvy-lookbook__hotspot"
        type="button"
        aria-controls="<?php echo $popup_id; ?>"
        aria-haspopup="dialog"
        aria-expanded="false"
        style="left:<?php echo $hs['x']; ?>%;top:<?php echo $hs['y']; ?>%;">
        <span class="savvy-lookbook__number"><?php echo $i + 1; ?></span>
      </button>

      <div id="<?php echo $popup_id; ?>" class="savvy-lookbook__popup<?php echo $popup_class; ?>" role="dialog" aria-label="<?php echo htmlspecialchars($hs['name']); ?>">
        <button class="savvy-lookbook__close" type="button" aria-label="Close"></button>
        <div class="savvy-lookbook__card">
          <a class="savvy-lookbook__thumb" href="<?php echo $hs['url']; ?>">
            <img src="<?php echo $hs['thumb']; ?>" alt="<?php echo htmlspecialchars($hs['name']); ?>" loading="lazy">
          </a>
          <div class="savvy-lookbook__info">
            <div class="savvy-lookbook__title">
              <a href="<?php echo $hs['url']; ?>"><?php echo htmlspecialchars($hs['name']); ?></a>
            </div>
            <div class="savvy-lookbook__price">
              <?php if ($hs['special']): ?>
              <del><?php echo $hs['price']; ?></del>
              <ins><?php echo $hs['special']; ?></ins>
              <?php else: ?>
              <ins><?php echo $hs['price']; ?></ins>
              <?php endif; ?>
            </div>
          </div>
        </div>
      </div>

      <?php endforeach; ?>

    </figure>
    <!-- ── /Lookbook ─────────────────────────────────────────────── -->

  </div>
</section>

<?php if ($js_url): ?>
<script src="<?php echo $js_url; ?>"></script>
<?php endif; ?>
