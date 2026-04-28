<?php
class ModelExtensionModuleBlookbook extends Model {

    /**
     * Save all settings for a given module instance.
     *
     * @param int   $module_id
     * @param array $data      POST data
     */
    public function saveSettings($module_id, $data) {
        // Remove old keys for this module instance before re-saving
        $this->db->query(
            "DELETE FROM `" . DB_PREFIX . "setting`
             WHERE `store_id` = '0'
               AND `code` = 'blookbook_" . (int)$module_id . "'"
        );

        $code = 'blookbook_' . (int)$module_id;

        // Status
        $this->saveSetting($code, 'status', isset($data['blookbook_status']) ? 1 : 0, false);

        // Image
        $image = isset($data['blookbook_image']) ? $data['blookbook_image'] : '';
        $this->saveSetting($code, 'image', $image, false);

        // Button URL (non-translatable)
        $btn_url = isset($data['blookbook_btn_url']) ? $data['blookbook_btn_url'] : '';
        $this->saveSetting($code, 'btn_url', $btn_url, false);

        // Hotspots — stored as JSON
        $hotspots = array();
        if (!empty($data['blookbook_hotspots']) && is_array($data['blookbook_hotspots'])) {
            foreach ($data['blookbook_hotspots'] as $hs) {
                if (isset($hs['x']) && isset($hs['y'])) {
                    $hotspots[] = array(
                        'x'          => round((float)$hs['x'], 2),
                        'y'          => round((float)$hs['y'], 2),
                        'product_id' => isset($hs['product_id']) ? (int)$hs['product_id'] : 0,
                    );
                }
            }
        }
        $this->saveSetting($code, 'hotspots', json_encode($hotspots), false);

        // Translatable fields per language
        if (!empty($data['blookbook_kicker']) && is_array($data['blookbook_kicker'])) {
            foreach ($data['blookbook_kicker'] as $lang_id => $val) {
                $this->saveSetting($code, 'kicker_' . (int)$lang_id, $val, false);
            }
        }

        if (!empty($data['blookbook_title']) && is_array($data['blookbook_title'])) {
            foreach ($data['blookbook_title'] as $lang_id => $val) {
                $this->saveSetting($code, 'title_' . (int)$lang_id, $val, false);
            }
        }

        if (!empty($data['blookbook_subtitle']) && is_array($data['blookbook_subtitle'])) {
            foreach ($data['blookbook_subtitle'] as $lang_id => $val) {
                $this->saveSetting($code, 'subtitle_' . (int)$lang_id, $val, false);
            }
        }

        if (!empty($data['blookbook_btn_label']) && is_array($data['blookbook_btn_label'])) {
            foreach ($data['blookbook_btn_label'] as $lang_id => $val) {
                $this->saveSetting($code, 'btn_label_' . (int)$lang_id, $val, false);
            }
        }

        // Points per language — stored as JSON per language
        if (!empty($data['blookbook_points']) && is_array($data['blookbook_points'])) {
            foreach ($data['blookbook_points'] as $lang_id => $points) {
                $clean_points = array();
                if (is_array($points)) {
                    foreach ($points as $pt) {
                        $clean_points[] = array(
                            'title' => isset($pt['title']) ? $pt['title'] : '',
                            'desc'  => isset($pt['desc'])  ? $pt['desc']  : '',
                        );
                    }
                }
                $this->saveSetting($code, 'points_' . (int)$lang_id, json_encode($clean_points), false);
            }
        }
    }

    /**
     * Load all settings for a module instance.
     *
     * @param  int   $module_id
     * @return array
     */
    public function getSettings($module_id) {
        $code = 'blookbook_' . (int)$module_id;

        $query = $this->db->query(
            "SELECT `key`, `value` FROM `" . DB_PREFIX . "setting`
             WHERE `store_id` = '0' AND `code` = '" . $this->db->escape($code) . "'"
        );

        $settings = array();
        foreach ($query->rows as $row) {
            $settings[$row['key']] = $row['value'];
        }

        return $settings;
    }

    /**
     * Search products for autocomplete.
     *
     * @param  string $keyword
     * @param  int    $limit
     * @return array
     */
    public function searchProducts($keyword, $limit = 10) {
        $lang_id = (int)$this->config->get('config_language_id');

        $query = $this->db->query(
            "SELECT p.product_id,
                    pd.name,
                    p.price,
                    p.image
             FROM `" . DB_PREFIX . "product` p
             LEFT JOIN `" . DB_PREFIX . "product_description` pd
                    ON p.product_id = pd.product_id
                   AND pd.language_id = '" . $lang_id . "'
             WHERE pd.name LIKE '%" . $this->db->escape($keyword) . "%'
               AND p.status = '1'
             ORDER BY pd.name ASC
             LIMIT " . (int)$limit
        );

        $results = array();

        $this->load->model('tool/image');

        foreach ($query->rows as $row) {
            $thumb = $row['image']
                ? $this->model_tool_image->resize($row['image'], 40, 40)
                : $this->model_tool_image->resize('no_image.png', 40, 40);

            $results[] = array(
                'product_id' => $row['product_id'],
                'name'       => $row['name'],
                'price'      => $this->currency->format($row['price'], $this->config->get('config_currency')),
                'thumb'      => $thumb,
            );
        }

        return $results;
    }

    // ── Private helpers ──────────────────────────────────────────────────────

    private function saveSetting($code, $key, $value, $serialized = false) {
        $this->db->query(
            "INSERT INTO `" . DB_PREFIX . "setting`
                (`store_id`, `code`, `key`, `value`, `serialized`)
             VALUES
                ('0',
                 '" . $this->db->escape($code) . "',
                 '" . $this->db->escape($code . '_' . $key) . "',
                 '" . $this->db->escape($value) . "',
                 '" . ($serialized ? 1 : 0) . "'
                )"
        );
    }
}