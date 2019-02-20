//商品权益
$(function () {
var fflag = false;
var sflag = false;
  var uiUseRestrictions = nova.ui({
    target: '.JS_form_group_use_restrictions'
  })
  uiUseRestrictions.render()

  var commodityRightsAndInterests = {
    init: function (options) {
      this.options = options
      this.bindEvent()
      this.validate()
      this.refreshRightAndInterestsInputDisabled()
    },
    createValidateMsg: function (type, text) {
      type = type || 'error'
      text = text || '未知错误'

      return '<span class="nova-tip-form">' +
        '<span class="nova-icon-xs nova-icon-' + type + '"></span>' +
        text +
        '</span>'
    },
    showTip: function ($formGroup, $ele, msg, type) {
      type = type || 'error'
      if ($ele.length) {
        $ele.html(msg).show()
      } else {
        $formGroup.append('<div class="form-' + type + '">' + msg + '</div>')
      }
    },
    validate: function () {
      var self = this
      var validateCallback = function (ret, val, $input, errorMessage) {
        var $formGroup = $input.parents('.form-group, .form-section, dd, td').first()
        var $formError = $formGroup.children('.form-error')
        var errorMsg = self.createValidateMsg('error', errorMessage)
        //验证通过
        if (ret) {
          $formError.hide()
          $input.removeClass('form-input-error')
          return true
        }
        //验证不通过
        self.showTip($formGroup, $formError, errorMsg)
        $input.addClass('form-input-error')
      }
      self.saveValidate = nova.validate({
        target: '.commodity-rights-and-interests-container',  //校验区域
        //验证规则
        rules: {
          // '.equity-label-list': {
          //   'equityLabelOne': true
          // },
          '.JS_account_type_select:not(:disabled)': {
            'required': true,
            'required-message': '请选择账户类型'
          },
          '.JS_valid_period_of_consumption_input:not(:disabled)': {
            'intDay': true
          },
          '.JS_validity_period_of_equity_input:not(:disabled)': {
            'intDay': true
          },
          '.JS_total_order_payable_input:not(:disabled)': {
            'required': true,
            'required-message': '必填',
            'floatPrice': true
          },
          '.form-group-categories-checkbox-box': {
            'requiredOneInSelect': true
          },
          '.form-control-unavailable-product-id': {
            'requiredInSelect': true,
            'idCSV': true
          },
          '.form-control-available-product-id': {
            'requiredInSelect': true,
            'idCSV': true
          },
          '.JS_rights_title_input:visible': {
        	'isLongLen': true,
            'required': true,
            'required-message': '标题不能为空',
            'minlength': '2',
            'minlength-message': '请输入2～140个字符',
            'maxlength': '140',
            'maxlength-message': '请输入2～140个字符'
          },
          '.JS_rights_content_input:visible': {
        	'isbigLen': true,
            'rightContent': true,
            'minlength': '2',
            'minlength-message': '请输入2-2000个字符',
            'maxlength': '2000',
            'maxlength-message': '请输入2-2000个字符'
          },
          '.JS_mailing_party_input:visible:not(:disabled)': {
            'required': true,
            'required-message': '请填写邮寄方'
          },
          '.JS_free_mail_radio_require_group': {
            'freeMailRequireOneInSelect': true
          }
        },
        //对组件进行扩展
        expandMethods: {
          intDay: function (value, $element) {
            var rule = /^\d+$/
            var ret = rule.test(value)

            if (value === '') {
              return true
            }

            var num = parseFloat(value)
            if (isNaN(num) === true) {
              //非数字
            } else {
              if (ret) {
                if (num >= 0 && num <= 99999) {
                  return true
                } else {
                  return '0-99999任意整数'
                }
              }
            }
            return '请输入整数'
          },
          floatPrice: function (value, $element) {
            var rule = /^\d+(\.\d{1,2})?$/
            var ret = rule.test(value)

            if (value === '') {
              return true
            }

            var num = parseFloat(value)
            if (isNaN(num) === true) {
              //非数字
            } else {
              if (ret) {
                if (num >= 0.00 && num <= 99999.00) {
                  return true
                } else {
                  return '输入有效值0-99999任意数字，可精确至小数点后两位数字'
                }

              }
            }
            return '请输入有效数字，可精确至小数点后两位数字'
          },
          requiredOneInSelect: function (value, $element) {
            var $itemList = $element.find('.JS_categories_checkbox_item')
            var $area = $element.parents('.JS_form_group_use_restrictions')
            var $checkbox = $area.find('.JS_checkbox_unavailable_categories')
            var checked = $checkbox.prop('checked')
            if (!checked) {
              return true
            }

            var hasOne = false
            for (var i = 0; i < $itemList.length; i++) {
              var $item = $itemList.eq(i)
              if ($item.prop('checked')) {
                hasOne = true
              }
            }
            if (hasOne) {
              return true
            }

            if ($element.parents('.form-group-categories-categories').length) {
              return '请选择品类'
            } else if ($element.parents('.form-group-categories-bu').length) {
              return '请选择BU'
            }

            return '请选择'
          },
          equityLabelOne: function (value, $element) {
            var $itemList = $element.find('.equity-label')

            if ($itemList.length) {
              return true
            }

            return '必填'
          },
          isbigLen: function (value, $element) {
              if(value.replace(/[^\x00-\xff]/g,'aa').length>=2 && value.replace(/[^\x00-\xff]/g,'aa').length<=2000){
            	  return true
              }
        	  return '请输入2-2000个字符'
          },
          isLongLen: function (value, $element) {
              if(value.replace(/[^\x00-\xff]/g,'aa').length>=2 && value.replace(/[^\x00-\xff]/g,'aa').length<=140){
            	  return true
              }
        	  return '请输入2-140个字符'
          },
          requiredInSelect: function (value, $element) {
            var $area = $element.parents('.JS_form_group_use_restrictions');
            var $checkbox;
            var msg = '';
            if($element.hasClass("form-control-unavailable-product-id")){
                $checkbox = $area.find('.JS_checkbox_unavailable_product_id');
                msg = '请输入不可用产品ID';
            }else{
                $checkbox = $area.find('.JS_checkbox_available_product_id');
                msg = '请输入可用产品ID';
            }
            var checked = $checkbox.prop('checked');
            if (!checked) {
              return true
            }

            if (value !== '') {
              return true
            }

            return msg;

          },
          idCSV: function (value, $element) {

            var csvRule = /^([^,]+,)*([^,]+)?$/
            var csvRet = csvRule.test(value)
            if (!csvRet) {
              return '请用英文“,”进行区分，如100004,284758,'
            }

            if (value.indexOf('，') !== -1) {
              return '请用英文“,”进行区分，如100004,284758,'
            }

            /*var rule = /^(\d+,)*(\d+)?$/
            var ret = rule.test(value)
            if (ret) {
              return true
            }*/

            var idArr = value.split(',')
            var numRule = /^(\d+)$/
            var errorArr = []
            for (var i = 0; i < idArr.length; i++) {
              var idItem = idArr[i]
              if (idItem.length !== 0 && !numRule.test(idItem)) {
                errorArr.push(idItem)
              }
            }

            if (errorArr.length === 0) {
              return true
            } else {
              return '以下产品ID有误：' + errorArr.join(',')
            }

            return '未知错误'
          },
          freeMailRequireOneInSelect: function (value, $element) {
            var $area = $element.parents('.form-group-need-mail')
            var $checkbox = $area.find('.JS_rights_need_mail_checkbox')
            var checked = $checkbox.prop('checked')
            if (!checked) {
              return true
            }

            var $radioListChecked = $area.find('.JS_exemption_from_postage_radio:checked')
            if ($radioListChecked.length) {
              return true
            }

            return '请选择是否免邮费'
          }
        },
        /**
         * 验证单个输入框回调方法
         * @param ret 输入框是否验证通过
         * @param val 输入框中的值
         * @param $input 输入框jQuery DOM对象
         * @param errorMessage 错误信息
         */
        validateCallback: validateCallback
      })
    },
    bindEvent: function () {
      var self = this
      $(document).on('click', '.JS_equity_label_btn', {self: self}, this.handleEquityLabelAdd)
      
      $(document).on('click', '.fgg', {self: self}, this.handleEquityLabelAdd2)
      $(document).on('click', '.sgg', {self: self}, this.handlelableEditSgg)
      $(document).on('mouseover', '#fli', {self: self}, this.fmouseover)
      $(document).on('mouseout', '#fli', {self: self}, this.fmouseout)
      $(document).on('mouseover', '.nova-dialog .form-control-add-cpt', {self: self}, this.smouseover)
      $(document).on('mouseout', '.nova-dialog .form-control-add-cpt', {self: self}, this.smouseout)
      $(document).on('click', '.JS_equity_label_edit', {self: self}, this.handleEquityLabelEdit)
      $(document).on('click', '.JS_equity_label_delete', {self: self}, this.handleEquityLabelDelete)
      $(document).on('mouseout', '.form-equity-view .JS_equity_label_input', {self: self}, this.handleEquityLabelChange2)
      $(document).on('blur', '.form-equity-view .JS_equity_label_input', {self: self}, this.handleEquityLabelChange)
      $(document).on('keyup', '.form-equity-view .JS_equity_label_input', {self: self}, this.handleEquityLabelChange1)
      $(document).on('mouseout', '.form-group-edit-label .JS_equity_label_input', {self: self}, this.handleDialogEquityLabelChange2)
      $(document).on('blur', '.form-group-edit-label .JS_equity_label_input', {self: self}, this.handleDialogEquityLabelChange)
      $(document).on('keyup', '.form-group-edit-label .JS_equity_label_input', {self: self}, this.handleDialogEquityLabelChange1)

      $(document).on('change', '.js_checkbox_rights_and_interests', {self: self}, this.handleCheckboxRightAndInterestsChange)
      $(document).on('change', '.JS_checkbox_unavailable_categories', {self: self}, this.handleCheckboxUnavailableCategoriesChange)
      $(document).on('change', '.JS_checkbox_unavailable_product_id', {self: self}, this.handleCheckboxRestrictProductIdChange)
      $(document).on('change', '.JS_checkbox_available_product_id', {self: self}, this.handleCheckboxRestrictProductIdChange)

      $(document).on('change', '.JS_categories_checkbox_item', {self: self}, this.handleCategoriesItemChange)
      $(document).on('change', '.JS_categories_checkbox_all', {self: self}, this.handleCategoriesAllChange)

      $(document).on('click', '.JS_all_page_save', {self: self}, this.handleAllPageSave)
      $(document).on('change', '.JS_rights_need_mail_checkbox', {self: self}, this.handleRightsNeedMailChange)

      $(document).on('click', '.JS_rights_btn_edit', {self: self}, this.handleRightsEditClick)
      $(document).on('click', '.JS_rights_btn_delete', {self: self}, this.handleRightsDeleteClick)
      $(document).on('click', '.JS_rights_btn_top', {self: self}, this.handleRightsTopClick)
      $(document).on('click', '.add-other-rights-and-interests', {self: self}, this.handleRightsAddClick)

      $(document).on('mouseenter', '.form-group-other-rights-state-edit .icon-delete-box', {self: self}, this.handleRightDeleteEnter)
      $(document).on('mouseleave', '.form-group-other-rights-state-edit .icon-delete-box', {self: self}, this.handleRightDeleteLeave)
    },
    //滚动页面至元素处
    scrollToElement: function ($ele, time) {
      if (time === void 0) { time = 200 }
      if (!($ele && $ele.length)) {
        return
      }
      var $window = $(window)
      var topOffset = $window.height() / 2
      var top = $ele.offset().top - topOffset
      $('html, body').stop(true, true).animate({
        scrollTop: top
      }, time)
    },
    handleRightDeleteEnter: function (e) {
      var self = e.data.self
      var $this = $(this)
      var $right = $this.parents('.form-group-other-rights')
      $right.addClass('form-group-other-rights-state-hover')

    },
    handleRightDeleteLeave: function (e) {
      var self = e.data.self
      var $this = $(this)
      var $right = $this.parents('.form-group-other-rights')
      $right.removeClass('form-group-other-rights-state-hover')

    },
    refreshEquityLabelListValidate: function () {
      $('.equity-label-list').change()
    },
    handleEquityLabelAdd: function (e) {
      var self = e.data.self
      var $area = $('.form-group-equity-label')
      var $input = $area.find('.JS_equity_label_input')
      var text = $.trim($input.val())
      if (text === '') {
        self.equityLabelError('名称不能为空')
        return
      }
      if (text.replace(/[^\x00-\xff]/g,'aa').length > 10 || text.replace(/[^\x00-\xff]/g,'aa').length < 2) {
        self.equityLabelError('名称，2～10个字符')
        return
      }
      var $equityLabelItemList = $area.find('.equity-label-list')
      var $equityLabelItem = $equityLabelItemList.find('.equity-label')
      if ($equityLabelItem.length >= 5) {
        self.equityLabelError('最多可添加5个标签')
        return
      }
      var suppGoodsId = $("#goodsId").val();
      var flag =true;
      $.each($(".equity-label"),function(){
    	  if($(this).find("b").html()==text){
    		  self.equityLabelError('标签名已存在');
    		  flag = fasle;
    		  return ;
    	  }
      });
      if(flag==true){
      $.ajax({
    	  url : "/vst_admin/finance/interestsBonus/addFinanceLable.do",
    	  type : "post",
    	  data :{lableName:text,suppGoodsId:suppGoodsId},
    	  success : function(result) {
    		  if(result.code == "success") {
    			  var $equityLabelItemClone = $area.find('.equity-label-list-template .equity-label').clone();
    		      $equityLabelItemClone.find('b').text(text);
    		      $equityLabelItemClone.find('.JS_equity_label_edit').attr("data",result.attributes.lableId);
    		      $equityLabelItemClone.find('.JS_equity_label_delete').attr("data",result.attributes.lableId);
    		      $equityLabelItemList.append($equityLabelItemClone);
    		      $input.val('');
    		      self.equityLabelError('');
    		      self.refreshEquityLabelListValidate();
    		  }else{
    			  nova.dialog({
    		            title: null,
    		            content: result.message,
    		            okCallback: function () {
    		            }
    		          })
    		  }
    		 
    	  },
    	  error : function(){
    		  nova.dialog({
		            title: null,
		            content: "添加失败",
		            okCallback: function () {
		            }
		          })
          }
      });
      }else{
    	  self.equityLabelError('标签名已存在')
      }
    },handlelableEditSgg: function (e) {
    	var $addCpt = $('.nova-dialog .form-control-add-cpt')
    	$addCpt.hide()
    	var $area=  $(".form-group-edit-label")
    	var $input=$area.find(".JS_equity_label_input")
    	$input.val($(this).html())
    	
    },
    fmouseout:function(e){
    	fflag = false;
    },
    fmouseover:function(e){
    	fflag = true;
    },
    smouseout:function(e){
    	sflag = false;
    },
    smouseover:function(e){
    	sflag = true;
    },
    handleEquityLabelAdd2: function (e) {
    	$("#fli").hide()
        var self = e.data.self
        var $area = $('.form-group-equity-label')
        var $input = $area.find('.JS_equity_label_input')
        $input.val($(this).html())
        var text = $.trim($input.val())
        if (text === '') {
          self.equityLabelError('名称不能为空')
          return
        }
        
        var $equityLabelItemList = $area.find('.equity-label-list')
        var $equityLabelItem = $equityLabelItemList.find('.equity-label')
        if ($equityLabelItem.length >= 5) {
          self.equityLabelError('最多可添加5个标签')
          return
        }
        var suppGoodsId = $("#goodsId").val();
        var flag =true;
        $.each($(".equity-label"),function(){
      	  if($(this).find("b").html()==text){
      		  self.equityLabelError('标签名已存在');
      		  flag = fasle;
      		  return ;
      	  }
        });
        if(flag==true){
        $.ajax({
      	  url : "/vst_admin/finance/interestsBonus/addFinanceLable.do",
      	  type : "post",
      	  data :{lableName:text,suppGoodsId:suppGoodsId},
      	  success : function(result) {
      		  if(result.code == "success") {
      			  var $equityLabelItemClone = $area.find('.equity-label-list-template .equity-label').clone();
      		      $equityLabelItemClone.find('b').text(text);
      		      $equityLabelItemClone.find('.JS_equity_label_edit').attr("data",result.attributes.lableId);
      		      $equityLabelItemClone.find('.JS_equity_label_delete').attr("data",result.attributes.lableId);
      		      $equityLabelItemList.append($equityLabelItemClone);
      		      $input.val('');
      		      self.equityLabelError('');
      		      self.refreshEquityLabelListValidate();
      		  }else{
      			  nova.dialog({
      		            title: null,
      		            content: result.message,
      		            okCallback: function () {
      		            }
      		          })
      		  }
      		 
      	  },
      	  error : function(){
      		  nova.dialog({
  		            title: null,
  		            content: "添加失败",
  		            okCallback: function () {
  		            }
  		          })
            }
        });
        }else{
      	  self.equityLabelError('标签名已存在')
        }
      },
    handleEquityLabelDelete: function (e) {
      var self = e.data.self
      var $this = $(this)
      var $equityLabelItem = $this.parents('.equity-label').eq(0);
      var lableId = $equityLabelItem.find('.JS_equity_label_delete').attr("data");
      var suppGoodsId = $("#goodsId").val();
      nova.dialog({
        title: null,
        width: 250,
        topFixed: true, 
        topOffset: 60,
        content: '是否确认删除该标签',
        okCallback: function () {
        	$.ajax({
        		url : "/vst_admin/finance/interestsBonus/deleteFinanceLable.do",
          	  type : "post",
          	  data :{lableId:lableId,suppGoodsId:suppGoodsId},
          	  success : function(result) {
          		if(result.code == "success") {
          			$equityLabelItem.remove();
                    self.refreshEquityLabelListValidate();
          		}else{
          			nova.dialog({
    		            title: null,
    		            content: result.message,
    		            okCallback: function () {
    		            }
    		          })
          		}
          	  },
          	 error : function(){
          		nova.dialog({
		            title: null,
		            content: "删除失败",
		            okCallback: function () {
		            }
		          })
             }
         });
        },
        cancelCallback: function () {

        }
      })

    },
    handleEquityLabelChange2: function (e) {
          		fflag = false;
      },
    handleEquityLabelChange: function (e) {
      var self = e.data.self
      var $this = $(this)
      var $area = $this.parents('.form-equity-view')
      var $error = $area.find('.JS_equity_label_error')
      $error.text('')
      if(fflag == true){
    	  $("#fli").show();
      }else{
    	  $("#fli").hide(); 
      }
    },
    handleEquityLabelChange1: function (e) {
        var self = e.data.self
        var $this = $(this)
        var $area = $this.parents('.form-equity-view')
        var $error = $area.find('.JS_equity_label_error')
        $error.text('')
        //新增标签
         $.ajax({
          	  url : "/vst_admin/finance/interestsBonus/queryFinanceLable.do",
          	  type : "post",
          	  data :{name:$(this).val()},
          	  success : function(result) {
          		  if(result.length>0){
          		  $("#fli").css("display","block");
          		  $("#fli").html("");
          		  for(var i =0;i<result.length;i++){
          			  var li ="<li class='fgg'>"+result[i].lableName+"</li>";
          			  $("#fli").append(li);
          		  }
          		//fflag =true;
          	  }else{
          		$("#fli").css("display","none"); 
          		//fflag =false;
          	  }
         }
         });  
        
        
        
      },
      handleDialogEquityLabelChange2: function (e) {
    	  sflag = false;
          //修改标签
        },
    handleDialogEquityLabelChange: function (e) {
      var self = e.data.self
      var $this = $(this)

      var $areaDialog = $this.parents('.form-group-edit-label')
      var $errorDialog = $areaDialog.find('.JS_equity_label_error')
      $errorDialog.text('')
      var $addCpt = $('.nova-dialog .form-control-add-cpt')
      if(sflag == true){
    	  $addCpt.show()
      }else{
    	  $addCpt.hide()
      }
      //修改标签
    },
    handleDialogEquityLabelChange1: function (e) {
        var self = e.data.self
        var $this = $(this)
        var $areaDialog = $this.parents('.form-group-edit-label')
        var $errorDialog = $areaDialog.find('.JS_equity_label_error')
        var $addCpt = $('.nova-dialog .form-control-add-cpt')
        //修改标签
        $.ajax({
        	  url : "/vst_admin/finance/interestsBonus/queryFinanceLable.do",
        	  type : "post",
        	  data :{name:$(this).val()},
        	  success : function(result) {
        		  if(result.length>0){
        		  $addCpt.show().html("");
        		  for(var i =0;i<result.length;i++){
        			  var li ="<li class='sgg'>"+result[i].lableName+"</li>";
        			  $addCpt.append(li);
        		  }
        	  }else{
        		  $addCpt.hide();
        	  }
       }
       });  
      },handleEquityLabelEdit: function (e) {
      var self = e.data.self
      var $this = $(this)
      var $equityLabelItem = $this.parents('.equity-label').eq(0);
      var lableId = $equityLabelItem.find('.JS_equity_label_edit').attr("data");
      $('.fgel-iptWrap .form-control-add-cpt').hide();
      nova.dialog({
        width: 300,
        title: '编辑标签',
        topFixed: true, 
        topOffset: 60,
        content: $('.equity-label-list-template .form-group-edit-label'),
        initCallback: function () {
          var $wrap = $(this.wrap)
          var oldText = $equityLabelItem.find('b').text()
          var $input = $wrap.find('.JS_equity_label_input')
          $input.val(oldText)
        },
        okCallback: function () {
          var $wrap = $(this.wrap)
          var $input = $wrap.find('.JS_equity_label_input')
          var text = $.trim($input.val())
          var $error = $wrap.find('.JS_equity_label_error')

          function dialogEquityLabelError (error) {
            $error.text(error)
          }

          if (text === '') {
            dialogEquityLabelError('名称不能为空')
            return false
          }
          if (text.replace(/[^\x00-\xff]/g,'aa').length > 10 || text.replace(/[^\x00-\xff]/g,'aa').length < 2) {
            dialogEquityLabelError('名称，2～10个字符')
            return false
          }
          
          var flag =true;
          $.each($(".equity-label"),function(){
        	  if($(this).find("b").html()==text){
        		  dialogEquityLabelError('标签名已存在');
        		  flag = fasle;
        		  return ;
        	  }
          });
          if(flag== true){
        	  
        	  $.ajax({
        		  url : "/vst_admin/finance/interestsBonus/updateFinanceLable.do",
        		  type : "post",
        		  data :{lableName:text,lableId:lableId,goodsId:$("#goodsId").val()},
        		  success : function(result) {
        			  if(result.code == "success") {
        				  var $equityLabelItemClone = $area.find('.equity-label-list-template .equity-label').clone();
        				  $equityLabelItemClone.find('b').text(text);
        				  $equityLabelItemClone.find('.JS_equity_label_edit').attr("data",result.attributes.lableId);
        				  $equityLabelItemClone.find('.JS_equity_label_delete').attr("data",result.attributes.lableId);
        				  $equityLabelItemList.append($equityLabelItemClone);
        				  $input.val('');
        				  self.equityLabelError('');
        				  self.refreshEquityLabelListValidate();
        			  }else{
        				  nova.dialog({
        					  title: null,
        					  content: result.message,
        					  okCallback: function () {
        					  }
        				  })
        			  }
        			  
        		  },
        		  error : function(){
        			  nova.dialog({
        				  title: null,
        				  content: "添加失败",
        				  okCallback: function () {
        				  }
        			  })
        		  }
        	  });
        	  
          }else{
        	  dialogEquityLabelError('标签名已存在')
          }
        	  

          $equityLabelItem.find('b').text(text)

        },
        cancelCallback: function () {
        	
        }
      })

    },
    equityLabelError: function (error) {
      $('.form-equity-view .JS_equity_label_error').text(error)
    },
    handleCheckboxRightAndInterestsChange: function (e) {
      var self = e.data.self
      var $area = $('.form-group-rights-and-interests')
      var $areaRight = $area.find('.form-group-rights-and-interests-right')
      var $checkbox = $('.js_checkbox_rights_and_interests')
      var isChecked = $checkbox.prop('checked')

      //若勾选后取消再重新勾选，之前的数值清空不保留
      if (!isChecked) {
        $areaRight.find(':text,textarea,select').val('')
        $areaRight.find(':checkbox ').prop('checked', false)

        uiUseRestrictions.render()
      }

      self.refreshRightAndInterestsInputDisabled()

    },
    /**
     * 刷新权益金右侧输入框
     */
    refreshRightAndInterestsInputDisabled: function () {
      var self = this

      var $checkbox = $('.js_checkbox_rights_and_interests')
      var isChecked = $checkbox.prop('checked')
      var $area = $('.form-group-rights-and-interests')
      var $areaRight = $area.find('.form-group-rights-and-interests-right')

      if (isChecked) {
        $areaRight.find(':input').prop('disabled', false)
      } else {
        $areaRight.find(':input').prop('disabled', true)
      }

      var $unavailableCategories = $('.JS_checkbox_unavailable_categories')
      var $groupCategories = $('.form-group-categories')
      if ($unavailableCategories.prop('checked')) {
        $groupCategories.find(':input').prop('disabled', false)
        $groupCategories.find('.nova-checkbox-label').removeClass('disabled')
      } else {
        $groupCategories.find(':input').prop('disabled', true)
        self.clearError($groupCategories)
      }

      var $unavailableProductId = $('.JS_checkbox_unavailable_product_id');
      var $banPid = $('.form-control-unavailable-product-id');
      if ($unavailableProductId.prop('checked')) {
          $banPid.prop('disabled', false);
      } else {
          $banPid.prop('disabled', true);
          self.clearError($banPid.closest(".form-group-product-id"));
      }

        var $availableProductId = $('.JS_checkbox_available_product_id');
        var $allowPid = $('.form-control-available-product-id');
        if ($availableProductId.prop('checked')) {
            $allowPid.prop('disabled', false);
        } else {
            $allowPid.prop('disabled', true);
            self.clearError($allowPid.closest(".form-group-product-id"));
        }

      if (!isChecked) {

        self.clearError($areaRight)
      }

      uiUseRestrictions.render()
    },
    handleAllPageSave: function (e) {
      var self = e.data.self
      var ret = self.options.allPageSaveCallback.call(self)
      if (ret === false) {
        return false
      }

      //self.saveOtherRightsList()

    },
    handleCheckboxUnavailableCategoriesChange: function (e) {
      var self = e.data.self
      var $this = $(this)

      var isChecked = $this.prop('checked')

      var $group = $('.form-group-categories')

      var $checkbox = $group.find(':checkbox')

      if (!isChecked) {
        $checkbox.prop('checked', false)
      }

      self.refreshRightAndInterestsInputDisabled()

    },
    handleCheckboxRestrictProductIdChange: function (e) {
      var $this = $(this);
      var $other;
      var $restrictProductId;
      if($this.hasClass("JS_checkbox_unavailable_product_id")){
          $other = $(".JS_checkbox_available_product_id");
          $restrictProductId = $(".form-control-unavailable-product-id");
      }else{
          $other = $(".JS_checkbox_unavailable_product_id");
          $restrictProductId = $(".form-control-available-product-id");
      }
      if($other.prop("checked")){
          $other.removeAttr("checked");
          $other.closest(".restrictPid").find(".form-group-product-id").find(":input").val("");
      }
      var self = e.data.self;
      self.refreshRightAndInterestsInputDisabled();
      if (!$this.prop('checked')) {
          $restrictProductId.val('');
      }
    },
    handleCategoriesItemChange: function (e) {
      var $this = $(this)
      var $area = $this.parents('dl').eq(0)
      var self = e.data.self

      var $all = $area.find('.JS_categories_checkbox_all')
      var $itemList = $area.find('.JS_categories_checkbox_item')
      var isAllSelect = true
      for (var i = 0; i < $itemList.length; i++) {
        var $item = $itemList.eq(i)
        if (!$item.prop('checked')) {
          isAllSelect = false
          break
        }
      }

      $all.prop('checked', isAllSelect)

      uiUseRestrictions.render()
    },
    handleCategoriesAllChange: function (e) {
      var $this = $(this)
      var $group = $this.parents('.form-group-categories-checkbox-box')
      var $area = $this.parents('dl').eq(0)
      var self = e.data.self

      var $all = $area.find('.JS_categories_checkbox_all')

      var allChecked = $all.prop('checked')

      var $itemList = $area.find('.JS_categories_checkbox_item')
      $itemList.prop('checked', allChecked)

      $group.change()
      uiUseRestrictions.render()
    },
    handleRightsNeedMailChange: function (e) {
      var self = e.data.self
      var $this = $(this)
      var $right = $this.parents('.form-group-other-rights')
      var checked = $this.prop('checked')
      var $mainDl = $right.find('.mail-dl')
      var $input = $mainDl.find(':input')
      $input.prop('disabled', !checked)

      if (!checked) {
        $input.filter(':text').val('')
        $input.filter(':radio').prop('checked', false)

        self.clearError($mainDl)
      }
    },
    clearError: function ($dom) {
      $dom.find('.form-error').remove()
      $dom.find('.form-input-error').removeClass('form-input-error')
    },
    saveOtherRightsList: function () {
      var self = this
      var $rightsList = $('.form-group-other-rights-list')
      var $rightsItems = $rightsList.find('.form-group-other-rights-state-edit')
      for (var i = 0; i < $rightsItems.length; i++) {
        var $rights = $rightsItems.eq(i)
        self.saveOtherRights($rights)
      }
    },
    saveOtherRights: function ($rights) {
      var title = $.trim($rights.find('.JS_rights_title_input').val())
      $rights.find('.right-view-title').text(title)

      var content = $.trim($rights.find('.JS_rights_content_input').val())
      $rights.find('.right-view-content').text(content)

      var $needMail = $rights.find('.JS_rights_need_mail_checkbox')
      var needMail = $needMail.prop('checked')
      if (needMail) {
        $rights.find('.right-view-need-mail').removeClass('right-view-need-mail-hidden')

        var $party = $rights.find('.JS_mailing_party_input')
        var party = $.trim($party.val())

        var $postageChecked = $rights.find('.JS_exemption_from_postage_radio:checked')
        var postage = $postageChecked.attr('data-value')

        $rights.find('.right-view-party').text(party)
        $rights.find('.right-view-postage').text(postage)

      } else {
        $rights.find('.right-view-need-mail').addClass('right-view-need-mail-hidden')
      }

      $rights.removeClass('form-group-other-rights-state-edit')
      $rights.removeClass('form-group-other-rights-state-new')
    },
    handleRightsEditClick: function (e) {
      var self = e.data.self
      var $this = $(this)
      var $rights = $this.parents('.form-group-other-rights')
      $rights.addClass('form-group-other-rights-state-edit')

    },
    handleRightsDeleteClick: function (e) {
      var self = e.data.self
      var $this = $(this)
      var $rights = $this.parents('.form-group-other-rights')

      var content = ''
      var editText = '该新增权益已有内容，是否确认删除'
      var viewText = '是否确认删除该权益'

      if ($rights.hasClass('form-group-other-rights-state-edit')) {
        content = editText
      } else {
        content = viewText
      }

      nova.dialog({
        width: 300,
        title: null,
        topFixed: true, 
        topOffset: $this.offset().top - $(window).scrollTop(),
        content: content,
        okCallback: function () {
          $rights.remove()
        },
        cancelCallback: function () {

        }
      })

    },
    handleRightsTopClick: function (e) {
      var self = e.data.self
      var $this = $(this)
      var $list = $('.form-group-other-rights-list')
      var $rights = $this.parents('.form-group-other-rights')

      $list.prepend($rights)

    },
    handleRightsAddClick: function (e) {
      var self = e.data.self
      var $this = $(this)
      var $template = $('.form-group-other-rights-template')
      var $newRights = $template.find('.form-group-other-rights').clone()

      var $list = $('.form-group-other-rights-list')

      var $oldRights = $list.find('.form-group-other-rights-state-new')
      if ($oldRights && $oldRights.length) {
        var $oldTitle = $oldRights.find('.JS_rights_title_input')
        var oldTitle = $.trim($oldTitle.val())

        if (oldTitle === '') {
          nova.dialog({
            title: null,
            masked: false,
            time: 3000,
            content: '当前权益标题为空，不可添加'
          })
          return
        }

      }

      $newRights.addClass('form-group-other-rights-state-edit')
      $list.find('.form-group-other-rights-state-new').removeClass('form-group-other-rights-state-new')
      $newRights.addClass('form-group-other-rights-state-new')
      
       var tlen=  $(".form-group-other-rights");
	   $.each($newRights.find(".JS_exemption_from_postage_radio"),function(){
	    	$(this).attr("name","postage_radio"+tlen.length); 
	   });
      $list.append($newRights)
      
    }
  }
  window.commodityRightsAndInterests = commodityRightsAndInterests

})


