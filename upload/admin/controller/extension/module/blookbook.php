<?php
class ControllerExtensionModuleBlookbook extends Controller {

    private $version = '1.0.0.0';

    public function __construct($registry) {
        parent::__construct($registry);
        $this->load->language('extension/module/blookbook');
    }

    private function render($template, $data) {
        $data = array_merge($this->language->all(), $data);
        return $this->load->view($template, $data);
    }

    // ── Main setting page ────────────────────────────────────────────────────

    public function index() {
        $data['version'] = $this->version;

        $this->load->model('setting/setting');
        $this->load->model('localisation/language');
        $this->load->model('tool/image');
        $this->load->model('catalog/product');

        $module_id = isset($this->request->get['module_id']) ? (int)$this->request->get['module_id'] : 0;

        // ── Document ─────────────────────────────────────────────────────────
        $this->document->setTitle($this->language->get('heading_title'));
        // ── Breadcrumbs ──────────────────────────────────────────────────────
        $data['breadcrumbs'] = array(
            array(
                'text' => $this->language->get('text_home'),
                'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], true),
            ),
            array(
                'text' => $this->language->get('text_extension'),
                'href' => $this->url->link('extension/extension', 'token=' . $this->session->data['token'] . '&type=module', true),
            ),
            array(
                'text' => $this->language->get('text_edit'),
                'href' => $this->url->link('extension/module/blookbook', 'token=' . $this->session->data['token'] . '&module_id=' . $module_id, true),
            ),
        );

        // ── Action URLs (decoded for AJAX/JS use) ────────────────────────────
        $data['action_save'] = html_entity_decode(
            $this->url->link('extension/module/blookbook/save', 'token=' . $this->session->data['token'] . '&module_id=' . $module_id, true),
            ENT_QUOTES, 'UTF-8'
        );
        $data['action_search_product'] = html_entity_decode(
            $this->url->link('extension/module/blookbook/searchProduct', 'token=' . $this->session->data['token'], true),
            ENT_QUOTES, 'UTF-8'
        );
        $data['cancel'] = $this->url->link('extension/extension', 'token=' . $this->session->data['token'] . '&type=module', true);

        // ── Load saved settings — direct DB read ────────────────────────────────
        // Bypasses getSetting() prefix-stripping ambiguity. Keys in DB are stored
        // as-is by editSetting() with the full blookbook_ prefix, e.g. blookbook_kicker_2.
        $q = $this->db->query(
            "SELECT `key`, `value` FROM `" . DB_PREFIX . "setting`
             WHERE `store_id` = '0' AND `code` = 'blookbook'"
        );
        $saved = array();
        foreach ($q->rows as $row) {
            $saved[$row['key']] = $row['value'];
        }

        // ── Status ────────────────────────────────────────────────────────────
        $data['blookbook_status'] = isset($saved['blookbook_status']) ? $saved['blookbook_status'] : 0;

        // ── Button URL ────────────────────────────────────────────────────────
        $data['blookbook_btn_url'] = isset($saved['blookbook_btn_url']) ? $saved['blookbook_btn_url'] : '';

        // ── Image ─────────────────────────────────────────────────────────────
        $image_path = isset($saved['blookbook_image']) ? $saved['blookbook_image'] : '';
        $data['blookbook_image'] = $image_path;
        $data['blookbook_thumb'] = $image_path
            ? $this->model_tool_image->resize($image_path, 120, 90)
            : '';
         $data['blookbook_thumb_hotspot'] = $image_path
            ? HTTPS_CATALOG.'image/'.$image_path
            : '';
        $base = $this->config->get('config_ssl') ? HTTPS_SERVER : HTTP_SERVER;
        $data['blookbook_image_url'] = $image_path ? $base . 'image/' . $image_path : '';
        $data['placeholder'] = $this->model_tool_image->resize('no_image.png', 120, 90);
        $data['placeholder_hotspot'] = $this->model_tool_image->resize('no_image.png', 900, 700);

        // ── Hotspots ──────────────────────────────────────────────────────────
        $hotspots_raw = isset($saved['blookbook_hotspots']) ? $saved['blookbook_hotspots'] : '[]';
        $hotspots     = json_decode($hotspots_raw, true);
        $hotspots     = is_array($hotspots) ? $hotspots : array();

        // Fetch product names for display in the hotspot table
        $lang_id = (int)$this->config->get('config_language_id');
        // foreach ($hotspots as &$hs) {
        //     if (!empty($hs['product_id'])) {
        //         $pq = $this->db->query(
        //             "SELECT pd.name FROM `" . DB_PREFIX . "product_description` pd
        //              WHERE pd.product_id = '" . (int)$hs['product_id'] . "'
        //                AND pd.language_id = '" . $lang_id . "' LIMIT 1"
        //         );
        //         $hs['product_name'] = $pq->num_rows ? $pq->row['name'] : '';
        //     } else {
        //         $hs['product_name'] = '';
        //     }
        // }
        // unset($hs);
        $data_hotspots = [];
        foreach ($hotspots as $hs) {
            $product_id = isset($hs['product_id']) ? (int)$hs['product_id'] : 0;
            if (!$product_id) continue;

            // Product info

            $p = $this->model_catalog_product->getProduct($product_id);

            // Price/special
            $price   = $this->currency->format($this->tax->calculate($p['price'], 0, $this->config->get('config_tax')), $this->config->get('config_currency'));

            // Thumb
            $thumb = $p['image']
                ? $this->model_tool_image->resize($p['image'], 80, 80)
                : $this->model_tool_image->resize('no_image.png', 80, 80);

            // Product URL
            $url = $this->url->link('catalog/product/edit', 'token='.$this->session->data['token'].'&product_id=' . $product_id);

            $data_hotspots[] = array(
                'x'           => (float)$hs['x'],
                'y'           => (float)$hs['y'],
                'product_id'  => $product_id,
                'product_name'        => $p['name'],
                'price'       => $price,
                'thumb'       => $thumb,
                'url'         => $url,
            );
        }
        $data['blookbook_hotspots'] = $data_hotspots;

        // ── Languages + translatable fields ───────────────────────────────────
        $languages = $this->model_localisation_language->getLanguages();
        $data['languages'] = $languages;

        $defaults = array(
            'kicker'    => 'Shop the Look',
            'title'     => 'The Complete <strong>Kitchen Setup.</strong>',
            'subtitle'  => 'Everything a serious cook needs — tap the hotspots to discover each piece.',
            'btn_label' => 'Shop the Collection',
        );

        $data['blookbook_kicker']    = array();
        $data['blookbook_title']     = array();
        $data['blookbook_subtitle']  = array();
        $data['blookbook_btn_label'] = array();
        $data['blookbook_points']    = array();

        foreach ($languages as $lang) {
            $lid = (int)$lang['language_id'];

            foreach (array('kicker', 'title', 'subtitle', 'btn_label') as $field) {
                $key = 'blookbook_' . $field . '_' . $lid;
                $data['blookbook_' . $field][$lid] = (isset($saved[$key]) && $saved[$key] !== '')
                    ? html_entity_decode($saved[$key], ENT_QUOTES, 'UTF-8') : $defaults[$field];
            }

            $points_raw = isset($saved['blookbook_points_' . $lid]) ? $saved['blookbook_points_' . $lid] : '[]';
            $pts = json_decode($points_raw, true);
            $data['blookbook_points'][$lid] = is_array($pts) ? $pts : array();
        }

        // ── Module ID ─────────────────────────────────────────────────────────
        $data['module_id'] = $module_id;

        // ── Layout ────────────────────────────────────────────────────────────
        $data['header']      = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer']      = $this->load->controller('common/footer');

        $this->response->setOutput($this->render('extension/module/blookbook', $data));
    }

    // ── AJAX: Save ────────────────────────────────────────────────────────────

    public function save() {
        $this->response->addHeader('Content-Type: application/json');

        if (!$this->user->hasPermission('modify', 'extension/module/blookbook')) {
            $this->response->setOutput(json_encode(array('error' => $this->language->get('error_permission'))));
            return;
        }

        $module_id = isset($this->request->get['module_id']) ? (int)$this->request->get['module_id'] : 0;

        // Normalize POST before passing to editSetting:
        // - hotspots array → JSON string
        // - points arrays  → JSON string per language
        // All other fields already have blookbook_ prefix from the form inputs.
        $post = $this->request->post;

        // Serialize hotspots → JSON
        $hotspots = array();
        if (!empty($post['blookbook_hotspots']) && is_array($post['blookbook_hotspots'])) {
            foreach ($post['blookbook_hotspots'] as $hs) {
                if (isset($hs['x']) && isset($hs['y'])) {
                    $hotspots[] = array(
                        'x'          => round((float)$hs['x'], 2),
                        'y'          => round((float)$hs['y'], 2),
                        'product_id' => isset($hs['product_id']) ? (int)$hs['product_id'] : 0,
                    );
                }
            }
        }
        $post['blookbook_hotspots'] = json_encode($hotspots);

        // Flatten translatable fields: editSetting() would serialize blookbook_kicker[2]
        // as a JSON object in one row. We need flat keys blookbook_kicker_2, blookbook_kicker_3
        // so each language value can be read back individually.
        foreach (array('kicker', 'title', 'subtitle', 'btn_label') as $field) {
            $field_key = 'blookbook_' . $field;
            if (!empty($post[$field_key]) && is_array($post[$field_key])) {
                foreach ($post[$field_key] as $lang_id => $val) {
                    $post['blookbook_' . $field . '_' . (int)$lang_id] = $val;
                }
                unset($post[$field_key]);
            }
        }

        // Flatten points per language → blookbook_points_{lang_id} as JSON string
        if (!empty($post['blookbook_points']) && is_array($post['blookbook_points'])) {
            foreach ($post['blookbook_points'] as $lang_id => $points) {
                $clean = array();
                if (is_array($points)) {
                    foreach ($points as $pt) {
                        $clean[] = array(
                            'title' => isset($pt['title']) ? $pt['title'] : '',
                            'desc'  => isset($pt['desc'])  ? $pt['desc']  : '',
                        );
                    }
                }
                $post['blookbook_points_' . (int)$lang_id] = json_encode($clean);
            }
            unset($post['blookbook_points']);
        }

        $this->load->model('setting/setting');

        // Always persist the version from code — never trust POST for this.
        $post['blookbook_version'] = $this->version;

        $this->model_setting_setting->editSetting('blookbook', $post);

        $this->response->setOutput(json_encode(array('success' => $this->language->get('text_success'))));
    }

    // ── AJAX: Product search ──────────────────────────────────────────────────

    public function searchProduct() {
        $this->response->addHeader('Content-Type: application/json');

        if (!$this->user->hasPermission('access', 'extension/module/blookbook')) {
            $this->response->setOutput(json_encode(array()));
            return;
        }

        $keyword = isset($this->request->get['keyword']) ? trim($this->request->get['keyword']) : '';

        $this->load->model('extension/module/blookbook');
        $results = $this->model_extension_module_blookbook->searchProducts($keyword);

        $this->response->setOutput(json_encode($results));
    }

    // ── Install / Uninstall ───────────────────────────────────────────────────

    public function install() {
        $this->load->model('user/user_group');
        $this->model_user_user_group->addPermission($this->user->getGroupId(), 'access', 'extension/module/blookbook');
        $this->model_user_user_group->addPermission($this->user->getGroupId(), 'modify', 'extension/module/blookbook');
    }

    public function uninstall() {
        // Settings left intentionally — standard OC pattern.
    }
}
