<?php
/* vim: set expandtab tabstop=4 shiftwidth=4: */
// +----------------------------------------------------------------------+
// | PHP version 4.0                                                      |
// +----------------------------------------------------------------------+
// | Copyright (c) 1997-2003 The PHP Group                                |
// +----------------------------------------------------------------------+
// | This source file is subject to version 2.0 of the PHP license,       |
// | that is bundled with this package in the file LICENSE, and is        |
// | available at through the world-wide-web at                           |
// | http://www.php.net/license/2_02.txt.                                 |
// | If you did not receive a copy of the PHP license and are unable to   |
// | obtain it through the world-wide-web, please send a note to          |
// | license@php.net so we can mail you a copy immediately.               |
// +----------------------------------------------------------------------+
// | Authors: Alexey Borzov <borz_off@cs.msu.su>                          |
// |          Bertrand Mansion <bmansion@mamasam.com>                     |
// |          Thomas Schulz <ths@4bconsult.de>                            |
// +----------------------------------------------------------------------+
//
// $Id: ArraySmarty.php,v 1.1 2004/08/23 14:19:26 tjdet Exp $

require_once 'HTML/QuickForm/Renderer/Array.php';

/**
 * A static renderer for HTML_QuickForm, makes an array of form content
 * useful for an Smarty template
 *
 * Based on old toArray() code and ITStatic renderer.
 *
 * The form array structure is the following:
 * Array (
 *  [frozen]       => whether the complete form is frozen'
 *  [javascript]   => javascript for client-side validation
 *  [attributes]   => attributes for <form> tag
 *  [hidden]       => html of all hidden elements
 *  [requirednote] => note about the required elements
 *  [errors] => Array
 *      (
 *          [1st_element_name] => Error for the 1st element
 *          ...
 *          [nth_element_name] => Error for the nth element
 *      )
 *
 *  [header] => Array
 *      (
 *          [1st_header_name] => Header text for the 1st header
 *          ...
 *          [nth_header_name] => Header text for the nth header
 *      )
 *
 *  [1st_element_name] => Array for the 1st element
 *  ...
 *  [nth_element_name] => Array for the nth element
 *
 * // where an element array has the form:
 *      (
 *          [name]      => element name
 *          [value]     => element value,
 *          [type]      => type of the element
 *          [frozen]    => whether element is frozen
 *          [label]     => label for the element
 *          [required]  => whether element is required
 * // if element is not a group:
 *          [html]      => HTML for the element
 * // if element is a group:
 *          [separator] => separator for group elements
 *          [1st_gitem_name] => Array for the 1st element in group
 *          ...
 *          [nth_gitem_name] => Array for the nth element in group
 *      )
 * )
 *
 * @access public
 */
class HTML_QuickForm_Renderer_ArraySmarty extends HTML_QuickForm_Renderer_Array
{
   /**
    * The Smarty template engine instance
    * @var object
    */
    var $_tpl = null;

   /**
    * Current element index
    * @var integer
    */
    var $_elementIdx = 0;

    /**
    * The current element index inside a group
    * @var integer
    */
    var $_groupElementIdx = 0;

   /**
    * How to handle the required tag for required fields
    * @var string
    * @see      setRequiredTemplate()
    */
    var $_required = '';

   /**
    * How to handle error messages in form validation
    * @var string
    * @see      setErrorTemplate()
    */
    var $_error = '';

   /**
    * Constructor
    *
    * @access public
    */
    function HTML_QuickForm_Renderer_ArraySmarty(&$tpl)
    {
        $this->HTML_QuickForm_Renderer_Array(true);
        $this->_tpl =& $tpl;
    } // end constructor

   /**
    * Called when visiting a header element
    *
    * @param    object     An HTML_QuickForm_header element being visited
    * @access   public
    * @return   void
    */
    function renderHeader(&$header)
    {
        if ($name = $header->getName()) {
            $this->_ary['header'][$name] = $header->toHtml();
        } else {
            $this->_ary['header'][$this->_sectionCount] = $header->toHtml();
        }
        $this->_currentSection = $this->_sectionCount++;
    } // end func renderHeader

   /**
    * Called when visiting a group, before processing any group elements
    *
    * @param    object     An HTML_QuickForm_group object being visited
    * @param    bool       Whether a group is required
    * @param    string     An error message associated with a group
    * @access   public
    * @return   void
    */
    function startGroup(&$group, $required, $error)
    {
        parent::startGroup($group, $required, $error);
        $this->_groupElementIdx = 1;
    } // end func startGroup

   /**
    * Creates an array representing an element containing
    * the key for storing this
    *
    * @access private
    * @param  object    An HTML_QuickForm_element object
    * @param  bool      Whether an element is required
    * @param  string    Error associated with the element
    * @return array
    */
    function _elementToArray(&$element, $required, $error)
    {
        $ret = parent::_elementToArray($element, $required, $error);

        if ('group' == $ret['type']) {
            $ret['html'] = $element->toHtml();
            // we don't need the elements, see the array structure
            unset($ret['elements']);
        }
        if (!empty($this->_required)){
            $this->_renderRequired($ret['label'], $ret['html'], $required, $error);
        }
        if (!empty($this->_error)) {
            $this->_renderError($ret['label'], $ret['html'], $error);
            $ret['error'] = $error;
        }
        // create keys for elements grouped by native group or name
        if (strstr($ret['name'], '[') or $this->_currentGroup) {
            preg_match('/([^]]*)\\[([^]]*)\\]/', $ret['name'], $matches);
            if (isset($matches[1])) {
                $sKeysSub = substr_replace($ret['name'], '', 0, strlen($matches[1]));
                $sKeysSub = str_replace(
                    array('['  ,   ']', '[\'\']'),
                    array('[\'', '\']', '[]'    ),
                    $sKeysSub
                );
                $sKeys = '[\'' . $matches[1]  . '\']' . $sKeysSub;
            } else {
                $sKeys = '[\'' . $ret['name'] . '\']';
            }
            // special handling for elements in native groups
            if ($this->_currentGroup) {
                // skip unnamed group items unless radios: no name -> no static access
                // identification: have the same key string as the parent group
                if ($this->_currentGroup['keys'] == $sKeys and 'radio' != $ret['type']) {
                    return false;
                }
                // reduce string of keys by remove leading group keys
                if (0 === strpos($sKeys, $this->_currentGroup['keys'])) {
                    $sKeys = substr_replace($sKeys, '', 0, strlen($this->_currentGroup['keys']));
                }
            }
        // element without a name
        } elseif ($ret['name'] == '') {
            $sKeys = '[\'element_' . $this->_elementIdx . '\']';
        // other elements
        } else {
            $sKeys = '[\'' . $ret['name'] . '\']';
        }
        // for radios: add extra key from value
        if ('radio' == $ret['type'] and substr($sKeys, -2) != '[]') {
            $sKeys .= '[\'' . $ret['value'] . '\']';
        }
        $this->_elementIdx++;
        $ret['keys'] = $sKeys;
        return $ret;
    } // end func _elementToArray

   /**
    * Stores an array representation of an element in the form array
    *
    * @access private
    * @param array  Array representation of an element
    * @return void
    */
    function _storeArray($elAry)
    {
        if ($elAry) {
            $sKeys = $elAry['keys'];
            unset($elAry['keys']);
            // where should we put this element...
            if (is_array($this->_currentGroup) && ('group' != $elAry['type'])) {
                $toEval = '$this->_currentGroup' . $sKeys . ' = $elAry;';
            } else {
                $toEval = '$this->_ary' . $sKeys . ' = $elAry;';
            }
            eval($toEval);
        }
        return;
    }

   /**
    * Called when an element is required
    *
    * This method will add the required tag to the element label and/or the element html
    * such as defined with the method setRequiredTemplate.
    *
    * @param    string      The element label
    * @param    string      The element html rendering
    * @param    boolean     The element required
    * @param    string      The element error
    * @see      setRequiredTemplate()
    * @access   private
    * @return   void
    */
    function _renderRequired(&$label, &$html, &$required, &$error)
    {
        $this->_tpl->assign(array(
            'label'    => $label,
            'html'     => $html,
            'required' => $required,
            'error'    => $error
        ));
        if (!empty($label) && strpos($this->_required, $this->_tpl->left_delimiter . '$label') !== false) {
            $label = $this->_tplFetch($this->_required);
        }
        if (!empty($html) && strpos($this->_required, $this->_tpl->left_delimiter . '$html') !== false) {
            $html = $this->_tplFetch($this->_required);
        }
        $this->_tpl->clear_assign(array('label', 'html', 'required'));
    } // end func _renderRequired

   /**
    * Called when an element has a validation error
    *
    * This method will add the error message to the element label or the element html
    * such as defined with the method setErrorTemplate. If the error placeholder is not found
    * in the template, the error will be displayed in the form error block.
    *
    * @param    string      The element label
    * @param    string      The element html rendering
    * @param    string      The element error
    * @see      setErrorTemplate()
    * @access   private
    * @return   void
    */
    function _renderError(&$label, &$html, &$error)
    {
        $this->_tpl->assign(array('label' => '', 'html' => '', 'error' => $error));
        $error = $this->_tplFetch($this->_error);
        $this->_tpl->assign(array('label' => $label, 'html'  => $html));

        if (!empty($label) && strpos($this->_error, $this->_tpl->left_delimiter . '$label') !== false) {
            $label = $this->_tplFetch($this->_error);
        } elseif (!empty($html) && strpos($this->_error, $this->_tpl->left_delimiter . '$html') !== false) {
            $html = $this->_tplFetch($this->_error);
        }
        $this->_tpl->clear_assign(array('label', 'html', 'error'));
    } // end func _renderError

   /**
    * Process an template sourced in a string with Smarty
    *
    * Smarty has no core function to render	a template given as a string.
    * So we use the smarty eval plugin function	to do this.
    *
    * @param    string      The template source
    * @access   private
    * @return   void
    */
    function _tplFetch($tplSource)
    {
        if (!function_exists('smarty_function_eval')) {
            require SMARTY_DIR . '/plugins/function.eval.php';
        }
        return smarty_function_eval(array('var' => $tplSource), $this->_tpl);
    }// end func _tplFetch

   /**
    * Sets the way required elements are rendered
    *
    * You can use {$label} or {$html} placeholders to let the renderer know where
    * where the element label or the element html are positionned according to the
    * required tag. They will be replaced accordingly with the right value.	You
    * can use the full smarty syntax here, especially a custom modifier for I18N.
    * For example:
    * {if $required}<span style="color: red;">*</span>{/if}{$label|translate}
    * will put a red star in front of the label if the element is required and
    * translate the label.
    *
    *
    * @param    string      The required element template
    * @access   public
    * @return   void
    */
    function setRequiredTemplate($template)
    {
        $this->_required = $template;
    } // end func setRequiredTemplate

   /**
    * Sets the way elements with validation errors are rendered
    *
    * You can use {$label} or {$html} placeholders to let the renderer know where
    * where the element label or the element html are positionned according to the
    * error message. They will be replaced accordingly with the right value.
    * The error message will replace the {$error} placeholder.
    * For example:
    * {if $error}<span style="color: red;">{$error}</span>{/if}<br />{$html}
    * will put the error message in red on top of the element html.
    *
    * If you want all error messages to be output in the main error block, use
    * the {$form.errors} part of the rendered array that collects all raw error
    * messages.
    *
    * If you want to place all error messages manually, do not specify {$html}
    * nor {$label}.
    *
    * Groups can have special layouts. With this kind of groups, you have to
    * place the formated error message manually. In this case, use {$form.group.error}
    * where you want the formated error message to appear in the form.
    *
    * @param    string      The element error template
    * @access   public
    * @return   void
    */
    function setErrorTemplate($template)
    {
        $this->_error = $template;
    } // end func setErrorTemplate
}
?>