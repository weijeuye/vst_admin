<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Title</title>
  <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/lv/buttons.css,/styles/lv/icons.css,/styles/lv/tips.css,/styles/lv/ui.css,/styles/lv/nova-calendar.css,/styles/lv/dialog.css">
  <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/vst/hg/common.css,/styles/backstage/vst/hg/product_equity.css">

</head>
<body class="commodity-rights-and-interests">

<div class="container commodity-rights-and-interests-container">
  <div class="container-crumbs">
    <a href="javascript:void(0)">金融</a>
    <i>&gt;</i>
    <a href="javascript:void(0)">商品维护</a>
    <i>&gt;</i>
    <a href="javascript:void(0)">销售信息</a>
    <i>&gt;</i>
    商品权益
  </div>

  <div class="container-title">
    <h2>权益标签：</h2>
  </div>

  <div class="section">
  	<input type="hidden" id="suppGoodsId" name="suppGoodsId" value="${suppGoodsId}">
    <dl class="form-group-equity-label">
      <dt>权益标签：</dt>
      <dd>
        <div class="form-equity-view">

          <input class="form-control form-control-add JS_equity_label_input" type="text" placeholder="名称，2～10个字符"
              maxlength="10">
          <div class="btn btn-blue JS_equity_label_btn">添加</div>
          <span class="error-message JS_equity_label_error"></span>
          <span class="form-tip">最多可添加5个标签</span>
          	<ul class="form-control-add-cpt" id="fli">
          	
              </ul>

        </div>
        <div class="equity-label-list clearfix">
        	<#if lableList?? &&  lableList?size &gt; 0>
        		<#list lableList as financeLable> 
			          <div class="equity-label">
			            <b>${(financeLable.lableName)!""}</b>
			            <i class="icon-edit JS_equity_label_edit" data="${(financeLable.lableId)!""}" title="点击编辑"></i>
			            <em></em>
			            <i class="icon-delete JS_equity_label_delete" data="${(financeLable.lableId)!""}" title="点击删除"></i>
			          </div>
	           </#list>
           	</#if>
       </div>
  
         
        
        <div class="equity-label-list-template">
          <div class="equity-label">
            <b></b>
            <i class="icon-edit JS_equity_label_edit" title="点击编辑"></i>
            <em></em>
            <i class="icon-delete JS_equity_label_delete" title="点击删除"></i>
          </div>
         
          <dl class="form-group-edit-label clearfix">
            <dt><em>*</em>标签名称：</dt>
            <dd class="fgel-iptWrap"><input class="form-control form-control-add JS_equity_label_input" type="text" placeholder="名称，2～10个字符"
                       maxlength="10">
              <div><span class="error-message JS_equity_label_error"></span></div>
               <ul class="form-control-add-cpt">
              </ul>
            </dd>
          </dl>
        </div>


      </dd>
    </dl>
  </div>

<form action="/vst_admin//finance/interestsBonus/saveInterestsBonus.do"  id="submitForm">
  <div class="container-title container-border">
  <input type="hidden" value="${(fInterestsBonus.interestsBonusId)!""}" id="interestsBonusId"/>
  <input type="hidden" value="${goodsId!""}" id="goodsId"/>
  <input type="hidden" value="${productId!""}" id="productId"/>
  
    <h2>权益内容：</h2>
  </div>
  <div class="section form-group-rights-and-interests">
    <dl>
      <dt>

        <div class="checkbox">
          <label>
          <#if fInterestsBonus??>
          <#if fInterestsBonus.interestsFlag=='on'>
            <input type="checkbox" name="interestsFlag" checked="checked" class="js_checkbox_rights_and_interests">
            权益金
            <#else>
             <input type="checkbox" name="interestsFlag" class="js_checkbox_rights_and_interests">
            权益金
            </#if>
            <#else>
            <input type="checkbox" name="interestsFlag" class="js_checkbox_rights_and_interests">
            权益金
            </#if>
          </label>
        </div>
      </dt>
      <dd class="section-inner form-group-rights-and-interests-right">

        <dl class="">
          <dt>标题：</dt>
          <dd>
            <div>
              <input class="form-control form-control-xxl" name="interestsBonusTitle" type="text" placeholder="0～200个字符" maxlength="200" value="${(fInterestsBonus.interestsBonusTitle)!""}"
              >
            </div>
          </dd>
        </dl>
        <dl class="">
          <dt><em>*</em>账户类型：</dt>
          <dd>
            <div>
              <select class="form-control JS_account_type_select" name="accountType" value="${(fInterestsBonus.accountType)!""}">
                <option value="">请选择</option>
                <#if accountType??>
                <#list accountType as atype>
                <option value="${(atype.code)!""}" <#if fInterestsBonus.accountType == atype.code>selected="selected"</#if> >${(atype.name)!""}</option>
                </#list>
                </#if>
              </select>
            </div>
          </dd>
        </dl>
        <dl class="form-group-valid-period-setting">
          <dt>有效期设置：</dt>
          <dd>
            <div>
              自发放之日起，消费金额有效期
              <div class="form-group">
                <span class="form-group-tip">（选填）</span>
                <input type="text"
                       class="form-control form-control-xs-add-plus JS_valid_period_of_consumption_input"
                       maxlength="5" name="consumLimit" value="${(fInterestsBonus.consumLimit)!""}">
              </div>
              天，权益金有效期
              <div class="form-group">
                <span class="form-group-tip">（选填）</span>
                <input type="text"
                       class="form-control form-control-xs-add-plus JS_validity_period_of_equity_input"
                       maxlength="5" name="interestsLimit" value="${(fInterestsBonus.interestsLimit)!""}">
              </div>
              天，根据订单应付总额
              <div class="form-group">
                <span class="form-group-tip"><em>*</em>（必填）</span>
                <input type="text"
                       class="form-control form-control-xs-add-plus JS_total_order_payable_input"
                       maxlength="8" name="interestsPercent" value="${(fInterestsBonus.interestsPercent)!""}">
              </div>
              %发放权益金。
            </div>
          </dd>
        </dl>
        <dl class="">
          <dt>使用限制：</dt>
          <dd class="section-inner-inner JS_form_group_use_restrictions">
            <div>
              <div class="checkbox">
                <label>
                <#if fInterestsBonus??>
                <#if fInterestsBonus.banCategory??>
                  <input type="checkbox" class="JS_checkbox_unavailable_categories" checked="checked">
                  不可用品类
                  <#else>
                  <input type="checkbox" class="JS_checkbox_unavailable_categories">
                  不可用品类
                  </#if>
                  <#else>
                  <input type="checkbox" class="JS_checkbox_unavailable_categories">
                  不可用品类
                  </#if>
                  
                </label>
              </div>
            </div>

            <div class="form-group-categories clearfix">

              <dl class="form-group-categories-categories clearfix">
                <dt><em>*</em>品类：</dt>
                <dd>

                  <div class="form-group-categories-checkbox-box">
                    <#if categoryList??>
                    <label class="nova-checkbox-label nova-checkbox-label-bordered ">
                    <#if cateList??>
                    <#if categoryList?size==cateList?size>
                      <input class="JS_categories_checkbox_all" type="checkbox" name="allBanCategory" checked="checked" value="">所有品类
                      <#else>
                      <input class="JS_categories_checkbox_all" type="checkbox" name="allBanCategory"  value="">所有品类
                      </#if>
                      <#else>
                      <input class="JS_categories_checkbox_all" type="checkbox" name="allBanCategory"  value="">所有品类
                      </#if>
                    </label>
                    <#list categoryList as category>
                    <#if cateList??>
                    	 <label class="nova-checkbox-label nova-checkbox-label-bordered ">
	                      <input class="JS_categories_checkbox_item" type="checkbox" name="banCategory" <#if cateList??&&cateList?seq_contains('${category.category_id}')> checked="checked"</#if> value="${(category.category_id)!""}">
	                      ${(category.category_name)!""}
                    		</label>
                    <#else>
                    <label class="nova-checkbox-label nova-checkbox-label-bordered ">
	                      <input class="JS_categories_checkbox_item" type="checkbox" name="banCategory" value="${(category.category_id)!""}">
	                      ${(category.category_name)!""}
                    		</label>
                    </#if>
                    </#list>
                  </#if>    
                  </div>
                </dd>
              </dl>
            </div>
            <div>
                选择适用产品范围：
            </div>
            <div class="restrictPid">
              <div class="checkbox" style="float: left">
                <label>
                <#if fInterestsBonus??>
                <#if fInterestsBonus.banPid??>
                  <input type="checkbox" checked="checked" class="JS_checkbox_unavailable_product_id">
                  不可用产品ID
                  <#else>
                  <input type="checkbox"  class="JS_checkbox_unavailable_product_id">
                  不可用产品ID
                  </#if>
                  <#else>
                  <input type="checkbox"  class="JS_checkbox_unavailable_product_id">
                  不可用产品ID
                  </#if>
                </label>
              </div>
                <div class="form-group-product-id" style="padding-left: 120px">
                    <div class="form-group">
                <textarea class="form-control form-control-unavailable-product-id" name="banPid"
                          placeholder="请用英文“,”进行区分，如100004,284758," onblur="fnBanPid()" maxlength="1000">${(fInterestsBonus.banPid)!""}</textarea>
                    </div>
                </div>
            </div>
            <div class="restrictPid" style="margin-top: 10px">
                <div class="checkbox" style="float: left">
                    <label>
                   <#if fInterestsBonus?? && fInterestsBonus.allowPid>
                       <input type="checkbox" checked="checked" class="JS_checkbox_available_product_id">
                       可用产品ID
                   <#else>
                       <input type="checkbox" class="JS_checkbox_available_product_id">
                       可用产品ID
                   </#if>
                    </label>
                </div>
                <div class="form-group-product-id" style="padding-left: 120px">
                    <div class="form-group">
                    <textarea class="form-control form-control-available-product-id" name="allowPid"
                              placeholder="请用英文“,”进行区分，如100004,284758," onblur="fnAllowPid()" maxlength="1000">${(fInterestsBonus.allowPid)!""}</textarea>
                    </div>
                </div>
            </div>
          </dd>
        </dl>
      </dd>
    </dl>

  </div>

  <div class="container-title container-border">
    <h2>其他权益：</h2>
  </div>
  <div class="section">
    <dl>
      <dt></dt>
      <dd>
        <div class="add-other-rights-and-interests">
          + 添加其他权益
        </div>
      </dd>
    </dl>
  </div>

  <div class="section">
    <div class="form-group-other-rights-list">
<#list financeOtherInterests as fins>
      <div class="form-group-other-rights">
        <div class="rights-controller">
          <ul class="clearfix">
            <li class="JS_rights_btn_edit icon-edit-box">
              <i class="icon-edit"></i>
              <b>编辑</b>
            </li>
            <li class="JS_rights_btn_delete icon-delete-box">
              <i class="icon-delete"></i>
              <b>删除</b>
            </li>
            <li class="JS_rights_btn_top icon-top-box">
              <i class="icon-top"></i>
              <b onclick="topFinance('${(fins.otherInterestsId)!""}','${goodsId}')">置顶</b>
            </li>
          </ul>
        </div>

        <div class="form-group-other-rights-view">
          <dl class="clearfix">
            <dt>标题：</dt>
            <dd>
              <div class="right-view-title">${(fins.otherInterestsContent)!""}</div>
            </dd>
          </dl>
          <dl class="clearfix">
            <dt>正文：</dt>
            <dd>
              <div class="right-view-content">${(fins.otherInterestsBody)!""}</div>

            </dd>
          </dl>
          <dl class="clearfix">
            <dt></dt>
            <dd>
              <div class="right-view-need-mail">

                <ul>
                <#if fins.otherInterestsMail??>
                  <li>需要邮寄</li>
                  <li>
                    邮寄方：
                    <span class="right-view-party">${(fins.otherInterestsMail)!""}</span>
                  </li>
                  <li>
                    是否免运费：
                    <#if fins.otherInterestsFreight=="0">
                    <span class="right-view-postage" fname="0">是</span>
                    <#else>
                    <span class="right-view-postage" fname="1">否</span>
                    </#if>
                  </li>
                  <#else>
                  <li>不需要邮寄</li>
                 </#if>
                 
                </ul>
              </div>
            </dd>
          </dl>
        </div>
        <div class="form-group-other-rights-edit" name="otherDiv">

            <dl class="clearfix">
              <dt><em>*</em>标题：</dt>
              <dd>
                <div>
                <input type="hidden" value="${(fins.otherInterestsId)!""}" name="otherInterestsId"/>
                  <input class="form-control form-control-xxl JS_rights_title_input" type="text"
                         placeholder="请输入2～140个字符" maxlength="140" name="otherInterestsContent" value="${(fins.otherInterestsContent)!""}"
                  >
                </div>
              </dd>
            </dl>
            <dl class="clearfix">
              <dt>正文：</dt>
              <dd>
                <div>
                  <textarea class="form-control JS_rights_content_input" placeholder="请输入2～2000个字符"
                            maxlength="2000" name="otherInterestsBody">${(fins.otherInterestsBody)!""}</textarea>
                </div>
              </dd>
            </dl>
            <dl class="clearfix">
              <dt></dt>
              <dd class="form-group-need-mail">
                <div class="mail-need-to-be-mailed">
                  <div class="checkbox">
                    <label>
                    <#if fins.otherInterestsMail??>
                      <input type="checkbox" class="JS_rights_need_mail_checkbox" checked="checked">
                      需要邮寄
                      <#else>
                       <input type="checkbox" class="JS_rights_need_mail_checkbox" >
                      需要邮寄
                      </#if>
                    </label>
                  </div>
                </div>


                <dl class="clearfix mail-dl mail-dl-mailing-party">
                  <dt><em>*</em>邮寄方：</dt>
                  <dd>
                    <input class="form-control form-control-xxl JS_mailing_party_input" type="text" <#if fins.otherInterestsMail??><#else>disabled</#if>
                           placeholder="" maxlength="2000" name="otherInterestsMail" value="${(fins.otherInterestsMail)!""}">

                  </dd>
                </dl>


                <dl class="clearfix mail-dl mail-dl-whether-it-is-free-from-postage">
                  <dt><em>*</em>是否免邮费：</dt>
                  <dd>
                    <div class="form-group">
                      <div class="JS_free_mail_radio_require_group">
                        <div class="radio">
                          <label>
                            <input type="radio"
                                   class="JS_exemption_from_postage_radio"
                                   name="otherInterestsFreight${(fins.otherInterestsId)!""}"
                                   value="0"
                                   data-value="是" <#if fins.otherInterestsFreight=="0">checked="checked"</#if>
                                   <#if fins.otherInterestsMail??><#else>disabled</#if>>
                            是
                          </label>
                        </div>
                        <div class="radio">
                          <label>
                            <input type="radio"
                                   class="JS_exemption_from_postage_radio"
                                   name="otherInterestsFreight${(fins.otherInterestsId)!""}"
                                   value="1"
                                   data-value="否" <#if fins.otherInterestsFreight=="1">checked="checked"</#if>
                                   <#if fins.otherInterestsMail??><#else>disabled</#if>>
                            否
                          </label>
                        </div>
                      </div>
                    </div>

                  </dd>
                </dl>

              </dd>
            </dl>

        </div>
      </div>
      </#list>
    </div>

    <div class="form-group-other-rights-template">
      <div class="form-group-other-rights">
        <div class="rights-controller">
          <ul class="clearfix">
            <li class="JS_rights_btn_edit icon-edit-box">
              <i class="icon-edit"></i>
              <b>编辑</b>
            </li>
            <li class="JS_rights_btn_delete icon-delete-box">
              <i class="icon-delete"></i>
              <b>删除</b>
            </li>
            <li class="JS_rights_btn_top icon-top-box">
              <i class="icon-top"></i>
              <b>置顶</b>
            </li>
          </ul>
        </div>

        <div class="form-group-other-rights-view">
          <dl class="clearfix">
            <dt>标题：</dt>
            <dd>
              <div class="right-view-title">奖励金额</div>
            </dd>
          </dl>
          <dl class="clearfix">
            <dt>正文：</dt>
            <dd>
              <div class="right-view-content">酒店门票签证奖励金额</div>

            </dd>
          </dl>
          <dl class="clearfix">
            <dt></dt>
            <dd>
              <div class="right-view-need-mail">

                <ul>
                  <li>需要邮寄</li>
                  <li>
                    邮寄方：
                    <span class="right-view-party">上海驴妈妈旅游网</span>
                  </li>
                  <li>
                    是否免运费：
                    <span class="right-view-postage">是</span>
                  </li>
                </ul>


              </div>
            </dd>
          </dl>
        </div>
        <div class="form-group-other-rights-edit" name="otherDiv">

            <dl class="clearfix">
              <dt><em>*</em>标题：</dt>
              <dd>
                <div>
                  <input class="form-control form-control-xxl JS_rights_title_input" type="text"
                         placeholder="请输入2～140个字符" maxlength="140" name="otherInterestsContent"
                  >
                </div>
              </dd>
            </dl>
            <dl class="clearfix">
              <dt>正文：</dt>
              <dd>
                <div>
                  <textarea class="form-control JS_rights_content_input" placeholder="请输入2～2000个字符"
                            maxlength="2000" name="otherInterestsBody"></textarea>
                </div>
              </dd>
            </dl>
            <dl class="clearfix">
              <dt></dt>
              <dd class="form-group-need-mail">
                <div class="mail-need-to-be-mailed">
                  <div class="checkbox">
                    <label>
                      <input type="checkbox" class="JS_rights_need_mail_checkbox">
                      需要邮寄
                    </label>
                  </div>
                </div>


                <dl class="clearfix mail-dl mail-dl-mailing-party">
                  <dt><em>*</em>邮寄方：</dt>
                  <dd>
                    <input class="form-control form-control-xxl JS_mailing_party_input" type="text" disabled
                           placeholder="" maxlength="140" name="otherInterestsMail">

                  </dd>
                </dl>


                <dl class="clearfix mail-dl mail-dl-whether-it-is-free-from-postage">
                  <dt><em>*</em>是否免邮费：</dt>
                  <dd>
                    <div class="form-group">
                      <div class="JS_free_mail_radio_require_group">
                        <div class="radio">
                          <label>
                            <input type="radio"
                                   class="JS_exemption_from_postage_radio"
                                   value="0"
                                   data-value="是"
                                   disabled>
                            是
                          </label>
                        </div>
                        <div class="radio">
                          <label>
                            <input type="radio"
                                   class="JS_exemption_from_postage_radio"
                                   value="1"
                                   data-value="否"
                                   disabled>
                            否
                          </label>
                        </div>
                      </div>
                    </div>

                  </dd>
                </dl>

              </dd>
            </dl>

        </div>
      </div>
    </div>
  </div>
  <div class="container-bottom btn-group">
    <a class="btn btn-xl btn-blue JS_poptip JS_all_page_save" tip-content="">保存</a>
  </div>
  </form>
</div>


<script src="http://pic.lvmama.com/js/backstage/vst/framework/jquery-1.11.3.min.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/lv/nova-calendar.js,/js/lv/validate.js,/js/lv/dialog.js,/js/lv/ui.js"></script>
<script src="/vst_admin/js/finance/product_equity.js"></script>
<script>
  $(function () {
    commodityRightsAndInterests.init({
      allPageSaveCallback: function () {
        console.log('save')
        var isValidate = this.saveValidate.getValidate()
        if (!isValidate) {
          //验证不通过，滚动到错误处
          this.scrollToElement($('.form-error:visible:first'))
          return false
        }
		var  array1 =new Array();
	    var  array2 =new Array();
	    var flag=$("input[name='interestsFlag']").is(':checked');
	    var allcate = $("input[name='allBanCategory']").is(':checked');
	    
	    if(flag==true){
		    var banca ="";
		    $('input[name="banCategory"]:checked').each(function(){ 
				banca+=$(this).val()+",";
			}); 
			var financeInterestsBonus={
				interestsBonusId:$("#interestsBonusId").val(),
				interestsFlag:$("input[name='interestsFlag']").val(),
				interestsBonusTitle:$("input[name='interestsBonusTitle']").val(),
				accountType:$("select[name='accountType']").val(),
				consumLimit:$("input[name='consumLimit']").val(),
				interestsLimit:$("input[name='interestsLimit']").val(),
				interestsPercent:$("input[name='interestsPercent']").val(),
				banPid:$("textarea[name='banPid']").val(),
                allowPid:$("textarea[name='allowPid']").val(),
				banCategory:banca
			}
			array1.push(financeInterestsBonus);
	    }
	    
	     $.each($(".form-group-other-rights-list [name='otherDiv']"),function(){
	        var otherInterestsId = $(this).find("input[name='otherInterestsId']").val();
	        var otherInterestsContent=$(this).find("input[name='otherInterestsContent']").val();
	        var otherInterestsBody=$(this).find("textarea[name='otherInterestsBody']").val();
	        var otherInterestsMail=$(this).find("input[name='otherInterestsMail']").val();
	        if(otherInterestsContent!=""){
		     	var otherInterests={
		     		otherInterestsId:otherInterestsId,
			     	otherInterestsContent:otherInterestsContent,
			     	otherInterestsBody:otherInterestsBody,
			        otherInterestsMail:otherInterestsMail,
			        otherInterestsFreight:$(this).find("input[type='radio']:checked").val()
		         }
		     	array2.push(otherInterests);
	     	}
	     });
	     if(array1==""){
		     alert("请填写完整数据再保存!");
		     return;
	     }
	     var asave = window.confirm("确认保存吗?");
        //模拟保存成功
        if(asave == true){
        var loadingDialog = nova.loading('<div class="nova-dialog-body-loading"><i></i><br>保存中...</div>')
         $.ajax({
                            url : "/vst_admin/finance/interestsBonus/saveInterestsBonus.do",
                            type : "post",
                            dataType : 'json',
                            data : {
	                            InterestsBonus:JSON.stringify(array1),
	                            otherInterestsBonus:JSON.stringify(array2),
	                            goodsId:$("#goodsId").val(),
	                            productId:$("#productId").val()
                            },
                            success : function(result) {
	                            if(result==1){
	                            setTimeout(function () {
	                            	alert("保存成功!");
	                            	loadingDialog.close(true);
                            	 	window.parent.descDialog.close();
                            	 	window.location.reload();
          						  }, 1 * 1000)
                            }else if(result==2){
                            	loadingDialog.close(true);
                            	alert("请填写完整数据再保存!");
                            }else{
                            	loadingDialog.close(true);
                            	alert("保存失败 请重试!");
                            }
                            },
                            error : function(result) {
                                 //超过60s未返回保存成功，返回保存失败，请重试
							        setTimeout(function () {
							          nova.dialog({
							            title: null,
							            content: '保存失败，请重试',
							            okText: '重试',
							            okCallback: function () {
							            }
							
							          })
							          loadingDialog.close(true)
							        }, 10 * 1000);
                            }
          });
	
}
      }
    })
  })
  
  
  function topFinance(obj,gid){
  		if(obj!="" && gid!=""){
	           $.ajax({
                            url : "/vst_admin/finance/interestsBonus/topInterestsBonus.do",
                            type : "post",
                            dataType : 'json',
                            data : {
	                            otherInterestsId:obj,
	                            goodsId:gid,
	                            productId:$("#productId").val()
                            },
                            success : function(result) {
                            },
                          
          });
	    }
  }
  
  $(function(){
  	Array.prototype.distinct = function(){
	 var arr = this,
	  result = [],
	  i,
	  j,
	  len = arr.length;
	 for(i = 0; i < len; i++){
	  for(j = i + 1; j < len; j++){
	   if(arr[i] === arr[j]){
	    j = ++i;
	   }
	  }
	  result.push(arr[i]);
	 }
	 return result;
	}
  });
  
  function fnBanPid(){
  var ohtml = $("textarea[name='banPid']").val();
     if(ohtml!=""){
     	var arra=ohtml.split(",");
     	arra=arra.distinct();
     	var str ="";
     	for(var i= 0;i<arra.length;i++){
     		if(i == arra.length-1){
     			str+=arra[i];
     		}else{
     			str+=arra[i]+","
     		}
     	}
     	
     	$("textarea[name='banPid']").val(str);
     	
     }
  }

  function fnAllowPid(){
      var ohtml = $("textarea[name='allowPid']").val();
      if(ohtml!=""){
          var arra=ohtml.split(",");
          arra=arra.distinct();
          var str ="";
          for(var i= 0;i<arra.length;i++){
              if(i == arra.length-1){
                  str+=arra[i];
              }else{
                  str+=arra[i]+","
              }
          }

          $("textarea[name='allowPid']").val(str);

      }
  }
  
</script>
</body>
</html>
