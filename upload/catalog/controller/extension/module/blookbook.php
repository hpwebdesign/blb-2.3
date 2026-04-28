<?php
class ControllerExtensionModuleBlookbook extends Controller {

    public function __construct($registry) {
        parent::__construct($registry);
        $this->load->language('extension/module/blookbook');
    }

    private function render($template, $data) {
        $data = array_merge($this->language->all(), $data);
        return $this->load->view($template, $data);
    }

    public function index() {
        $code      = 'blookbook';
        $this->load->model('catalog/product');
        // ── Load raw settings ────────────────────────────────────────────────
        // $raw = $this->config->get($code);
       
            // fallback: read directly from oc_setting
            $q = $this->db->query(
                "SELECT `key`, `value` FROM `" . DB_PREFIX . "setting`
                 WHERE `store_id` = '0' AND `code` = '" . $this->db->escape($code) . "'"
            );
            $raw = array();
            foreach ($q->rows as $row) {
                $raw[$row['key']] = $row['value'];
            }
        

        // Status check
        $status = isset($raw[$code . '_status']) ? (int)$raw[$code . '_status'] : 0;
        if (!$status) {
            return '';
        }

        // ── Detect active language ───────────────────────────────────────────
        $lang_id = (int)$this->config->get('config_language_id');

        // ── Translatable fields ──────────────────────────────────────────────
        $data['kicker']    = isset($raw[$code . '_kicker_' . $lang_id])
            ? html_entity_decode($raw[$code . '_kicker_' . $lang_id], ENT_QUOTES, 'UTF-8') : '';
        $data['title']     = isset($raw[$code . '_title_' . $lang_id])
            ? html_entity_decode($raw[$code . '_title_' . $lang_id], ENT_QUOTES, 'UTF-8') : '';
        $data['subtitle']  = isset($raw[$code . '_subtitle_' . $lang_id])
            ? html_entity_decode($raw[$code . '_subtitle_' . $lang_id], ENT_QUOTES, 'UTF-8') : '';
        $data['btn_label'] = isset($raw[$code . '_btn_label_' . $lang_id])
            ? html_entity_decode($raw[$code . '_btn_label_' . $lang_id], ENT_QUOTES, 'UTF-8') : '';

        // ── Button URL ───────────────────────────────────────────────────────
        $data['btn_url'] = isset($raw[$code . '_btn_url']) ? $raw[$code . '_btn_url'] : '';

        // ── Image ────────────────────────────────────────────────────────────
        $image_path = isset($raw[$code . '_image']) ? $raw[$code . '_image'] : '';
        $this->load->model('tool/image');
        $data['image'] = $image_path
            ? HTTPS_SERVER.'image/'.$image_path
            : '';

        if (!$data['image']) {
            return ''; // Nothing to show without an image
        }

        // ── Points ───────────────────────────────────────────────────────────
        $points_raw = isset($raw[$code . '_points_' . $lang_id])
            ? $raw[$code . '_points_' . $lang_id] : '[]';
        $pts = json_decode($points_raw, true);
        $data['points'] = is_array($pts) ? $pts : array();

        // ── Hotspots ─────────────────────────────────────────────────────────
        $hotspots_raw = isset($raw[$code . '_hotspots']) ? $raw[$code . '_hotspots'] : '[]';
        $hotspots_data = json_decode($hotspots_raw, true);
        $hotspots_data = is_array($hotspots_data) ? $hotspots_data : array();

        // Fetch product details for each hotspot
        $data['hotspots'] = array();
        foreach ($hotspots_data as $hs) {
            $product_id = isset($hs['product_id']) ? (int)$hs['product_id'] : 0;
            if (!$product_id) continue;

            // Product info

            $p = $this->model_catalog_product->getProduct($product_id);

            // Price/special
            $price   = $this->currency->format($this->tax->calculate($p['price'], 0, $this->config->get('config_tax')), $this->config->get('config_currency'));
            $special = '';

            if ($p['special']) {
                $special = $this->currency->format($this->tax->calculate($p['special'], 0, $this->config->get('config_tax')), $this->config->get('config_currency'));
            }

            // Thumb
            $thumb = $p['image']
                ? $this->model_tool_image->resize($p['image'], 80, 80)
                : $this->model_tool_image->resize('no_image.png', 80, 80);

            // Product URL
            $url = $this->url->link('product/product', 'product_id=' . $product_id);

            $data['hotspots'][] = array(
                'x'           => (float)$hs['x'],
                'y'           => (float)$hs['y'],
                'product_id'  => $product_id,
                'name'        => $p['name'],
                'price'       => $price,
                'special'     => $special,
                'thumb'       => $thumb,
                'url'         => $url,
            );
        }

        // ── CSS / JS URLs ────────────────────────────────────────────────────
        $base = $this->config->get('config_ssl') ? HTTPS_SERVER : HTTP_SERVER;
        $data['css_url'] = $base . 'catalog/view/javascript/blookbook.css';
        $data['js_url']  = $base . 'catalog/view/javascript/blookbook.js';

        return $this->render('extension/module/blookbook', $data);
    }
}
