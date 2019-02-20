<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>商品描述</title>
  <script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/ui-common.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/ui-components.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/iframe.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/normalize.css" type="text/css"/>
  <link rel="stylesheet" href="http://super.lvmama.com/vst_admin/css/base.css" type="text/css"/>
  <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/v1/vst/base.css,/styles/lv/dialog.css">
  <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/v1/vst/product-feature/product-feature.css">
  <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/vst/gallery/v1/reset.css,/styles/backstage/vst/gallery/v1/flat.css,/styles/backstage/vst/gallery/v1/product-input/product-input-carousel.css">
  <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst/hg/product_des.css">
</head>
<body>
<div class="iframe_header">
  <ul class="iframe_nav">
    <li><a href="javascript:void(0)">金融</a> &gt;</li>
    <li><a href="javascript:void(0)">商品维护</a> &gt;</li>
    <li><a href="javascript:void(0)">销售信息</a> &gt;</li>
    <li class="active">商品描述</li>
  </ul>
</div>
<div class="iframe_content mt10">

  <div class="p_box box_info mt10 goodsDes editing">
    <div class="title">
      <h2 class="f16 ">商品描述：</h2>
      <a class="btn btn-primary js_addNewDes" id="new_button">添加商品描述</a>
    </div>
    <#if financeList?? && (financeList?size > 0) >
    <#list financeList as flist>
    <div class="p_line box_content proDes">
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
      <table class="e_table form-inline">
        <tbody>
        <tr>
        <td class="e_label w12">大标题：</td>
        <td>${(flist.mainSubject)!""}</td>
        </tr>
        <tr>
        <td class="e_label w12">小标题：</td>
        <td>${(flist.subSubject)!""}</td>
        </tr>
        <tr>
        <td class="e_label w12">正文：</td>
        <td>${(flist.content)!""}</td></tr>
        </tbody>
      </table>
    <!--隐藏域，保存从数据库读到的原始信息-->
    <input type="hidden" class="js_hid-goodsDescId" value="${(flist.goodsDescId)!""}">
    <input type="hidden" class="js_hid-bigTit" value="${(flist.mainSubject)!""}">
    <input type="hidden" class="js_hid-smallTit" value="${(flist.subSubject)!""}">
    <input type="hidden" class="js_hid-con" value="${(flist.content)!""}">
    </div>
      </#list>
     </#if>
    
  </div>
</div>

<div class="template">
	
	<!--插入图片 开始-->
  <div class="pf-insert-picture" style="width:758px;height:480px;">

    <div class="pf-insert-header">
      图片模板：
      <a id="btn1" class="btn btn-primary">1张图</a>
      <a id="btn2" class="btn">2张图</a>
      <a id="btn3" class="btn">3张图</a>
      <a id="btn4" class="btn">自定义图片</a>
    </div>
    <div class="pf-insert-body" style="height:354px;">
      <!--1张图 开始-->
      <div id="divInsetr1" flag="picTmp" class="pf-insert-pane active" data-template="pf-movable-picture-one">
        <div class="pf-insert-pane-header">
          * 1张图模板，上传的图片会自动裁切为1080*432像素大小。
        </div>
        <div class="pf-insert-pane-one">
          <div class="picture" data-id="11" data-width="1080" data-height="432" data-fixed-width="true"
               style="width:756px;height:302px"
               data-fixed-height="true">
            <img id="imgInsert1" style="width:756px;height:302px">
            <div class="shadow"></div>
            <div class="re-choice"></div>
            <div class="choice">选择图片
            </div>
          </div>
          <!--
          图片上显示文字：<input class="input-text pf-picture-info" id="pictureInfo" type="text" placeholder="选填，30字以内" maxlength="30">
          -->
        </div>
      </div>
      <!--1张图 结束-->

      <!--2张图 开始-->
      <div flag="picTmp" id="divInsetr2" class="pf-insert-pane" data-template="pf-movable-picture-two">
        <div class="pf-insert-pane-header"></div>
        <div class="pf-insert-pane-two">
          <ul class="pictures clearfix">
            <li class="picture" data-id="21" data-width="530" data-height="353" data-fixed-width="true"
                style="width:371px;height:247px"
                data-fixed-height="true">
              <img id="imgInsert21" style="width:371px;height:247px">
              <div class="shadow"></div>
              <div class="re-choice"></div>
              <div class="choice">选择图片
              </div>
            </li>
            <li class="picture" data-id="22" data-width="530" data-height="353" data-fixed-width="true"
                style="width:371px;height:247px"
                data-fixed-height="true">
              <img id="imgInsert22" style="width:371px;height:247px">
              <div class="shadow"></div>
              <div class="re-choice"></div>
              <div class="choice">选择图片
              </div>
            </li>
          </ul>
        </div>
      </div>
      <!--2张图 结束-->

      <!--3张图 开始-->
      <div flag="picTmp" id="divInsetr3" class="pf-insert-pane" data-template="pf-movable-picture-three">
        <div class="pf-insert-pane-three">
          <div class="pf-insert-pane-header"></div>
          <ul class="pictures clearfix">
            <li class="picture" data-id="31" data-width="347" data-height="231" data-fixed-width="true"
                style="width:243px;height:162px"
                data-fixed-height="true">
              <img id="imgInsert31" style="width:243px;height:162px">
              <div class="shadow"></div>
              <div class="re-choice"></div>
              <div class="choice">选择图片
              </div>
            </li>
            <li class="picture" data-id="32" data-width="347" data-height="231" data-fixed-width="true"
                style="width:243px;height:162px"
                data-fixed-height="true">
              <img id="imgInsert32" style="width:243px;height:162px">
              <div class="shadow"></div>
              <div class="re-choice"></div>
              <div class="choice">选择图片
              </div>
            </li>
            <li class="picture" data-id="33" data-width="347" data-height="231" data-fixed-width="true"
                style="width:243px;height:162px"
                data-fixed-height="true">
              <img id="imgInsert33" style="width:243px;height:162px">
              <div class="shadow"></div>
              <div class="re-choice"></div>
              <div class="choice">选择图片
              </div>
            </li>
          </ul>
        </div>
      </div>
      <!--3张图 结束-->

      <!--自定义图片 开始-->
      <div flag="picTmp" id="divInsetr4" class="pf-insert-pane" data-template="pf-movable-picture-custom">
        <div class="pf-insert-pane active">
          <div class="pf-insert-pane-header">
            * 上传自定义图片，宽度最小1080像素，高度不限。
          </div>
          <div class="pf-insert-pane-custom">
            <div class="multiple-picture picture" data-id="41" data-width="1080" data-height="432"
                 data-fixed-width="true" style="width:756px;height:302px"
                 data-fixed-height="false">
              <img id="imgInsert41" style="width:756px;height:302px">
              <div class="shadow"></div>
              <div class="re-choice"></div>
              <div class="choice">选择图片
              </div>
            </div>
            <!--多图模板-->
            <div class="multiple-picture-list">
              <ol class="cf upload-lists" style="width:760px;height:340px;overflow: auto;padding:10px 0 0 15px;">
                <li class="upload-item-new JS_multiple_picture_add" style="width:215px;height:164px;">
                  <i></i>
                  添加图片
                </li>

              </ol>
              <p class="multiple-picture-list-info" style="text-align:center">
                无版权图片慎用，一经发生版权纠纷，责任自负！&nbsp;&nbsp;&nbsp;&nbsp;</span>
                <a class="btn JS_multiple_picture_add" style="margin-left:525px;margin-top:-25px;width:70px;">添加图片</a>
              </p>
            </div>
          </div>
        </div>
      </div>
      <!--自定义图片 结束-->

    </div>
    <div class="pf-insert-pane-btn-group" style="margin-left:700px;margin-top:30px;width:700px;">
      <a class="btn JS_picture_btn_ok">确定</a>
    </div>

  </div>
	




  <!--添加商品描述 开始-->
  <form action="/vst_admin/finance/goods/saveSuppGoodsDesc.do" class="p_line js_newDes" id="submitForm">
  <input type="hidden" value="${goodsId!""}" name="goodsId" id="goodsId"/>
  <input type="hidden" value="${productId!""}" name="productId" id="productId"/>
    <div class="box_content">
      <table class="e_table form-inline">
        <tbody>
        <tr>
          <td class="e_label w12">大标题：</td>
          <td>
            <label><input type="text" class="w35" name="mainSubject" id="mainSubject">&nbsp;<span style="color:grey">请输入2~200个字符</span></label>
            <div id="bigTitError" class="errorBox"></div>
            <div class="showCon"></div>
          </td>
        </tr>
        <tr>
          <td class="e_label">小标题：</td>
          <td>
            <label><input type="text" class="w35" name="subSubject" id="subSubject">&nbsp;<span style="color:grey">请输入2~200个字符</span></label>
            <div id="smallTitError" class="errorBox"></div>
            <div class="showCon"></div>
          </td>
        </tr>
        <tr>
          <td class="e_label">正文：</td>
          <td>
            <label>
              <textarea class="w35 textWidth" name="content" id="content" style="width:700px; height:50px;resize: none;"></textarea>
              <span style="color:grey">请输入2-2000个字符</span>
            </label>

            <div id="contentError" class="errorBox"></div>
            <div class="showCon"></div>
          </td>
        </tr>
        <tr>
          <td class="e_label">图片：</td>
          <td>
          <div class="uploadPicWrap">
           <div class="imgUploaded clearfix">
               <ul class="upload-add-image-ul" data-tag="guideImgs">
                        <li class="uploadPic-head" data-tag="addimg" >
                            <a class="btn js_upload_pic">+ 添加图片</a>
                            <span class="uploadPic-del js_morDel">批量删除</span>
                        </li>
                </ul>
                  </div>
            </div>
          </td>
        </tr>
        </tbody>
      </table>
      <div class="goodsDes-option">
        <a class="btn btn-primary js_save">完成</a>
        <a class="btn js_cancelSave">取消</a>
      </div>
    </div>
    <!--隐藏域，保存从数据库读到的原始信息-->
    <input type="hidden" class="js_hid-goodsDescId">
    <input type="hidden" class="js_hid-bigTit">
    <input type="hidden" class="js_hid-smallTit">
    <input type="hidden" class="js_hid-con">
  </form>
  <!--添加商品描述 结束-->

  <!--商品描述 开始-->
  <div class="p_line box_content proDes">
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
    <table class="e_table form-inline">
        <tbody>
        <tr>
          <td class="e_label">图片：</td>
          <td>
            <div class="imgUploaded clearfix">
                <ul>
                  <li class="drag-ele">
                    <p class="img-head">86794966</p>
                    <img src="http://pic.lvmama.com/uploads/pc/place2/2017-07-21/f212ce36-93a3-4875-8128-8ec6f99b1a56.jpg"
                         width="130" height="86" class="picImg32">
                    <p class="img-info">蜈支洲岛_VCG2185b628a14.jpg</p>
                  </li>
                </ul>
              </div>
          </td>
        </tr>
        </tbody>
      </table>
    
    <!--隐藏域，保存从数据库读到的原始信息-->
    <input type="hidden" class="js_hid-goodsDescId">
    <input type="hidden" class="js_hid-bigTit">
    <input type="hidden" class="js_hid-smallTit">
    <input type="hidden" class="js_hid-con">
    </div>
 <!--商品描述 结束-->
</div>

			<div class="edit-template" style="display: none">
 					<li class="drag-ele" data-pic="">
			                    <p class="img-head">
			                      <label class="photoList"><input type="checkBox" name="checkPhotos" value=""></label>
			                      <i title="删除" class="js_delPhoto">×</i>
			                    </p>
			                    <img src="http://placehold.it/210x140/d9d9d9"
			                         width="130" height="86" class="picImg32">
			                    <p class="img-info"></p>
			                    <input type="hidden" id="fileId" name="imgurls" value="">
                  			</li>

</div>

<script type="text/javascript" src="http://super.lvmama.com/vst_admin/js/log.js"></script>
<!--公用脚本 START-->
<script
  src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common/dialog.js,js/backstage/v1/common/validate.js,js/backstage/v1/common/float-alert.js,js/backstage/v1/common/sortable.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/vst/product-feature/product-feature.js,/js/lv/dialog.js"></script>
<script type="text/javascript" src="http://super.lvmama.com/vst_admin/js/log.js"></script>
<script type="text/javascript" src="http://super.lvmama.com/vst_admin/js/jquery.easyui.min-1.3.1.js"></script>
<script type="text/javascript" src="http://super.lvmama.com/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="http://super.lvmama.com/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="http://super.lvmama.com/vst_admin/js/messages_zh.js"></script>

<!--<script type="text/javascript" src="http://super.lvmama.com/vst_admin/js/pandora-dialog.js"></script>-->

<!--公用脚本 END-->


<script>
var $currentPictureTemplate=null;
    //JQuery 自定义验证
    jQuery.validator.addMethod("isCharCheck", function (value, element) {
        var chars = /^([\u4e00-\u9fa5]|[a-zA-Z0-9]|[\+-]|[\u0020])+$/;//验证特殊字符
        return this.optional(element) || (chars.test(value));
    }, "不可为空或者特殊字符");

    // 中文字两个字节
    jQuery.validator.addMethod("byteRangeLength", function (value, element, param) {
        var length = value.length;
        for (var i = 0; i < value.length; i++) {
            if (value.charCodeAt(i) > 127) {
                length++;
            }
        }
        return this.optional(element) || ( length >= param[0] && length <= param[1] );
    }, $.validator.format("请确保输入的值在{0}-{1}个字节之间(一个中文字算2个字节)"));

    $(function () {
        var $document = $(document),
            $addNewDes = $('.js_addNewDes ');
            
		var flag = true;
        //添加商品描述
        var $goodsDes = $('.goodsDes');
        $addNewDes.on('click', function(){
          var $this = $(this);
          var $content = $('.template>.js_newDes').clone();
          if (!$goodsDes.find('.js_newDes').length && flag == true) {
            $goodsDes.append($content).addClass('editing');
            $this.addClass('btn-forbidden').removeClass('btn-primary');
          } else {

          }

        });

        //验证规则
        var fomeRules = {
            rules: {
                mainSubject: {
                    //required: true,
                    //isCharCheck: true,
                    byteRangeLength: [2, 200],
                },
                subSubject: {
                    //required: true,
                    //isCharCheck: true,
                    byteRangeLength: [2, 200],
                },
                content: {
                    //required: true,
                    byteRangeLength: [2, 2000],
                }
            },
            messages: {
                mainSubject: '请输入2~140个字符且不可为空或者特殊字符',
                subSubject: '请输入2~140个字符且不可为空或者特殊字符',
                content: '请输入2~2000个字符',
            }
        };

        //编辑状态转成详情展示
        function toDes(obj) {
            var $proDes = $('.template>.proDes').clone();
            var html = '';
            if(obj.mainSubject) {
                html += '<tr><td class="e_label w12">大标题：</td><td>' + obj.mainSubject + '</td></tr>';
                $proDes.find('.js_hid-bigTit').val(obj.mainSubject);
            }
            if(obj.subSubject) {
                html += '<tr><td class="e_label w12">小标题：</td><td>' + obj.subSubject + '</td></tr>';
                $proDes.find('.js_hid-smallTit').val(obj.subSubject);
            }
            if(obj.content) {
                html += '<tr><td class="e_label w12">正文：</td><td>' + obj.content + '</td></tr>';
                $proDes.find('.js_hid-con').val(obj.content);
            }
            if(obj.goodsDescId){
            	$proDes.find('.js_hid-goodsDescId').val(obj.goodsDescId);
            }
            //填充图片
            //可自行完成，可与前端联调
			 $proDes.find('tbody').html(html);
            obj.pForm.before($proDes).remove();
        }

        // 保存操作
        $document.on('click', '.goodsDes .js_save', function () {
            var $newDes = $(".goodsDes form"),
                $mainSubject = $newDes.find('input[name=mainSubject]'),
                $subSubject = $newDes.find('input[name=subSubject]'),
                $goodsDescId = $newDes.find('.js_hid-goodsDescId');
                $content = $newDes.find('textarea'),
                mainSubjectVal = $mainSubject.val().replace(/^\s+|\s+$/g,""),
                subSubjectVal = $subSubject.val().replace(/^\s+|\s+$/g,""),
                contentVal = $content.val().replace(/^\s+|\s+$/g,"");
            if (!$newDes.validate(fomeRules).form()) {
                return false;
            } else {
                if (!mainSubjectVal && !subSubjectVal && !contentVal) {
                    nova.dialog({
                        content: '至少填写一项',
                        width: 300,
                        topFixed: true,
                		topOffset: 50,
                        okCallback: true,
                        okClassName: 'btn-primary',
                        wrapClass: 'delMorPicAlert',
                    });
                    return false;
                }
            }
			var  array1 =new Array();
			var  array2 =new Array();
			var div=$(".template");
       	    var sdiv=div.prev();
             $.each(sdiv.find("ul[data-tag='guideImgs']").find("img"),function(){
             	var financePhotosVo = {
             		imgurl:$(this).attr("src")
             	}
             	 array1.push(financePhotosVo);
             });
			
				var financeSuppGoodsDesc = {
                    goodsId:$("#goodsId").val(),
                    mainSubject:$("#mainSubject").val(),
                    subSubject:$("#subSubject").val(),
                    content:$("#content").val()
                };
                
                array2.push(financeSuppGoodsDesc);
			
            //执行保存操作
            //将按钮改成可点状态
            $addNewDes.removeClass('btn-forbidden').addClass('btn-primary');
            var $pForm = $(this).parents('form');
					           

            //填充保存完后显示的内容
              $.ajax({
                            url : "/vst_admin/finance/goods/saveSuppGoodsDesc.do",
                            type : "post",
                            dataType : 'json',
                            data : {
	                            guideStrJpg:JSON.stringify(array1),
	                            guideStrDesc:JSON.stringify(array2),
	                            goodsDescId:$goodsDescId.val(),
	                            productId:$("#productId").val()
                            },
                            success : function(result) {
                            	 var objDes = {
					                pForm: $pForm,
					                mainSubject: result.mainSubject,
					                subSubject: result.subSubject,
					                content: result.content,
					                goodsDescId:result.goodsDescId
					            };
                                toDes(objDes);
                                flag = true;
                            },
                            error : function(result) {
                                alert(result);
                            }
                        });
           


        });

        //取消保存
        $document.on('click', '.js_cancelSave', function () {
           var $pForm = $(this).parents('form');
            nova.dialog({
                content: '是否确认取消',
                width: 300,
                okClassName: 'btn-primary',
                wrapClass: 'delMorPicAlert',
                topFixed: true,
                topOffset: 50,
                cancelCallback: true,
                okCallback: function() {
                    if($pForm.hasClass('js_newDes')){
                        //是新增的，直接删除
                        $pForm.remove();
                        if (!$goodsDes.find('.proDes').length) {
                            //$goodsDes.removeClass('editing');
                        }
                        $addNewDes.removeClass('btn-forbidden').addClass('btn-primary');
                        flag = true;
                    } else {
                      // 不是新增的，则需恢复原来的内容
                        var objDes = {
                            pForm: $pForm,
                            mainSubject: $pForm.find('.js_hid-bigTit').val(),
                            subSubject: $pForm.find('.js_hid-smallTit').val(),
                            content: $pForm.find('.js_hid-con').val(),
                            goodsDescId:$pForm.find('.js_hid-goodsDescId').val(),
                            img: {}
                        };
                        toDes(objDes);
                    	$addNewDes.removeClass('btn-forbidden').addClass('btn-primary');
                    	flag = true;
                    }
                }
            });
        });
        
        //编辑商品信息
        $document.on('click','.JS_rights_btn_edit', function () {
            var $parent = $(this).parents('.proDes');
            if (!$goodsDes.find('.js_newDes').length) {
            	flag = false;
       			$goodsDes.find("#new_button").addClass('btn-forbidden').removeClass('btn-primary');
          }

            //先检查是否存在正在编辑或正在新增的，需把取消掉
            var $newDes = $goodsDes.find('.js_newDes'),
                $editing = $goodsDes.find('.js_editing');
            if ($newDes.length) {
                $newDes.remove();
            } else if($editing.length) {
                //有正在编辑的，取隐藏域内的信息
                var objDes = {
                    pForm: $editing,
                    mainSubject: $editing.find('.js_hid-bigTit').val(),
                    subSubject: $editing.find('.js_hid-smallTit').val(),
                    content: $editing.find('.js_hid-con').val(),
                    goodsDescId:$editing.find('.js_hid-goodsDescId').val()
                };
                toDes(objDes);
                // 正在编辑的取消掉
                $editing.remove();
            }

            //正式编辑开始，取数据库中的此条数据，进行填充
               $.ajax({
                            url : "/vst_admin/finance/goods/queryComphotoUrl.do",
                            type : "post",
                            dataType : 'json',
                            data : {
	                            "goodsDescId":$parent.find('.js_hid-goodsDescId').val()
                            },
                            success : function(result) {
                             //alert(result);
                             //demo用页面的显示数据，之后换数据库异步取的
					            var ajxval = {
					                big: $parent.find('.js_hid-bigTit').val(),
					                small: $parent.find('.js_hid-smallTit').val(),
					                con: $parent.find('.js_hid-con').val(),
					                goodsDescId:$parent.find('.js_hid-goodsDescId').val()
					            };
					            //填充表单及隐藏域
					            var $content = $('.template>.js_newDes').clone();
					            $content.removeClass('js_newDes').addClass('js_editing');
					            $content.find('input[name=mainSubject]').val(ajxval.big);
					            $content.find('input[name=subSubject]').val(ajxval.small);
					            $content.find('textarea').val(ajxval.con);
					
					            $content.find('.js_hid-bigTit').val(ajxval.big);
					            $content.find('.js_hid-smallTit').val(ajxval.small);
					            $content.find('.js_hid-con').val(ajxval.con);
								$content.find('.js_hid-goodsDescId').val(ajxval.goodsDescId);
					            $parent.before($content).remove();
					            for(var i=0;i<result.length;i++){
                					addImg(result[i].photoUrl);
            					}
                            },
                            error : function(result) {
                                alert(result);
                            }
                        });
        });

        //删除描述
        $document.on('click','.JS_rights_btn_delete',function () {
        var $parent = $(this).parents('.proDes');
            var $this = $(this);
            nova.dialog({
                content: '是否确认删除该描述',
                width: 300,
                okClassName: 'btn-primary',
                topFixed: true,
                topOffset: 50,
                wrapClass: 'delMorPicAlert',
                cancelCallback: true,
                okCallback: function() {
                    //执行异步删除操作
                     $.ajax({
                            url : "/vst_admin/finance/goods/deleteSuppGoodsDesc.do",
                            type : "post",
                            dataType : 'json',
                            data : {
	                            goodsDescId:$parent.find('.js_hid-goodsDescId').val(),
	                            productId:$("#productId").val(),
	                            goodsId:$("#goodsId").val()
                            },
                            success : function(result) {
                              if(result>0){
                            	$this.parents('.proDes').remove();
			                    if (!$goodsDes.find('.proDes').length && ! $goodsDes.find('form').length) {
			                        $goodsDes.removeClass('editing');
			                    }}else{
			                    	alert("删除失败，请稍后再试!");
			                    }
                            },
                            error : function(result) {
                                alert(result);
                            }
                        });
                    
                    
                    
                    
                    
                   
                }
            })
        });
        
         
         


        //置顶操作
        $document.on('click','.JS_rights_btn_top', function () {
        	
        	 var $parent = $(this).parents('.proDes');
        	 var goodsDescId = $parent.find('.js_hid-goodsDescId').val();
        	 var goodsid =$("#goodsId").val();
        	 location.href="/vst_admin/finance/goods/topSuppGoodsDesc.do?goodsDescId="+goodsDescId+"&goodsId="+goodsid;
        	   /*$.ajax({
                            url : "/vst_admin/finance/goods/topSuppGoodsDesc.do",
                            type : "post",
                            dataType : 'json',
                            data : {
	                            goodsDescId:$parent.find('.js_hid-goodsDescId').val(),
	                            productId:$("#productId").val()
                            },
                            success : function(result) {
                              if(result>0){
                            	$this.parents('.proDes').remove();
			                    if (!$goodsDes.find('.proDes').length && ! $goodsDes.find('form').length) {
			                        $goodsDes.removeClass('editing');
			                    }}else{
			                    	alert("删除失败，请稍后再试!");
			                    }
                            },
                            error : function(result) {
                                alert(result);
                            }
                        });*/
        
        
        
            var $parent = $(this).parents('.proDes').remove();
            var $content = $parent.clone();
            $goodsDes.find('.title').after($content);
        });

       

        //自定义图片-显示列表
        

      
        // 批量删除
        $document.on('click', ".js_morDel", function () {
            var $this = $(this),
                nLen = $this.parents('.uploadPicWrap').find('input[name=checkPhotos]:checked').length; //选中的图片数量

            if (!nLen) {
                nova.dialog({
                    content: '请先选择要删除的图片',
                    width: 300,
                    okCallback: true,
                    topFixed: true,
                    topOffset: 50,
                    okClassName: 'btn-primary',
                    wrapClass: 'delMorPicAlert',
                });
                return false;
            }
            nova.dialog({
                content: '是否确认删除' + nLen + '张图片',
                title: null,
                showClose: false,
                width: 300,
                topFixed: true,
                topOffset: 50,
                wrapClass: 'delMorPicAlert',
                okCallback: function() {
                  // 执行批量操作
                     $.each($this.parents('.uploadPicWrap').find('input[name=checkPhotos]:checked'),function(){
                     $(this).closest(".drag-ele").remove();
                 }); 
                },
                cancelCallback: true,
                okClassName: 'btn-primary'
            });
        });

        // 单张删除
        $document.on('click', '.js_delPhoto', function () {
        	
            var $this = $(this),
            closex= $this.closest('.drag-ele');
            nova.dialog({
                content: '确定删除？',
                width: 300,
                topFixed: true,
                topOffset: 50,
                okClassName: 'btn-primary',
                wrapClass: 'delMorPicAlert',
                cancelCallback: true,
                okCallback: function() {
                    // 执行删除操作
                    //alert($(this).parent().html());
             		closex.remove();
                }
            });
        });

    });
    Date.prototype.Format = function (fmt) { //author: fangxiang
        var o = {
            "M+": this.getMonth() + 1, //月份
            "d+": this.getDate(), //日
            "h+": this.getHours(), //小时
            "m+": this.getMinutes(), //分
            "s+": this.getSeconds(), //秒
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度
            "S": this.getMilliseconds() //毫秒
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    }
    
    
    
	var imageOperate2;
	var imageOperate;
	$(".multiple-picture-list .JS_multiple_picture_add").live("click",function(){
        var $this = $(this);
        choosePicture($this,false);
    });
		/*选择图片*/
		$(".pf-insert-picture .picture").live("click",function(){
            var $this = $(this);
            choosePicture($this, true);
        });
        //图片弹框
        function choosePicture($this, single) {
            $currentPicture = $this;
            $currentPictureTemplate = $this;

            var url = "http://super.lvmama.com/photo-back/photo/photo/imgPlugIn.do?relationId=" + $("#productId").val() + "&relationType=1";
            var nowDate = new Date();
            nowDate = nowDate.Format("YYYYMMDD");
            url += "&photoSource=vst&relationTime=" + nowDate;
            var dataId = $this.attr("data-id");
            if (dataId == "11") {
                url += "&imgLimitSize=LIMIT_1080_432";
            }
            if (dataId == "21" || dataId == "22") {
                url += "&imgLimitType=LIMIT_3_2_3L&imgLimitSize=LIMIT_530_353";
            }
            if (dataId == "31" || dataId == "32" || dataId == "33") {
                url += "&imgLimitType=LIMIT_3_2_3L&imgLimitSize=LIMIT_347_231";
            }
            if (dataId == "41") {
                url += "&imgLimitSize=LIMIT_1080_";
            }
            if (single) {
                url += "&imgLimitNum=single";
            }
            imageOperate = backstage.dialog({
                title: "选择或上传图片",
                iframe: true,
                url: url,
                width: 850,
                height: 610
            });

        }
         $(".JS_picture_btn_ok").live("click",function(){
			var imgArr = new Array();
        	$(".nova-dialog").find("div[flag='picTmp']").each(function(){
        		$(this).find(".picture").find("img").each(function(){
        			var src = $(this).attr("src");
	        		if(typeof(src) != "undefined" && src!=""){
	        			imgArr.push(src);
	        		}
        		
        		});
        	});
        	
        	$(".nova-dialog").find(".multiple-picture-list ol").each(function(){
        		$(this).find("img").each(function(){
        		var src = $(this).attr("src");
	        		if(typeof(src) != "undefined" && src!=""){
	        			imgArr.push(src);
	        		}
        		});
        	});
        	
        	for(var i =0;i<imgArr.length;i++){
        		addImg2(imgArr[i]);
        	}
            imageOperate2.close();
        });


    
    $(".js_upload_pic").live("click",function(){
            var $content = $(".pf-insert-picture").clone();
            $content.find("#divInsetr4").attr("data-batch-type", "true");
            imageOperate2 = nova.dialog({
              title: "插入图片",
              width: 820,
              height: 545,
              content: $content,
              topFixed: true,
              topOffset: 50
            });
            multipleList();
        });
     
    function multipleList() {
            $(".multiple-picture-list").show();
            $(".multiple-picture").hide();
        }
    
    
     /**
     * 上传图片回调函数
     * @param picob
     */
    function photoCallback(picob){
        window.console && console.log(picob);
        var imgindex = $currentPictureTemplate.closest(".picture").find("img");
        if(picob!=null && picob.success==true){
        	imageOperate.destroy();
            var photos=picob.photos;
	            for(var i=0;i<photos.length;i++){
	             	var src =  photos[i].photoOriginUrl;
	         		var img ="http://pic.lvmama.com/"+src;
	                if(imgindex.attr("id")=="imgInsert1"){
	                	$(".nova-dialog #imgInsert1").attr("src",img);
	                }else if(imgindex.attr("id")=="imgInsert21"){
	                	$(".nova-dialog #imgInsert21").attr("src",img);
	                }else if(imgindex.attr("id")=="imgInsert22"){
	                	$(".nova-dialog #imgInsert22").attr("src",img);
	                }else if(imgindex.attr("id")=="imgInsert31"){
	                	$(".nova-dialog #imgInsert31").attr("src",img);
	                }else if(imgindex.attr("id")=="imgInsert32"){
	                	$(".nova-dialog #imgInsert32").attr("src",img);
	                }else if(imgindex.attr("id")=="imgInsert33"){
	                	$(".nova-dialog #imgInsert33").attr("src",img);
	                }else{
	                	var src =  photos[i].photoOriginUrl;
		         		var img ="http://pic.lvmama.com/"+src;
		         		var li="<li class='upload-item-new JS_multiple_picture_add' style='width:100px;height:100px;'><img src='"+img+"' style='width:100px;height:100px;'/></li>";
		         		$(".nova-dialog").find(".multiple-picture-list ol").append(li);
	                }
	            }
        }else{
            //错误提示
            nova.dialog({
                content:"上传错误",
                topFixed: true,
                topOffset: 50,
                wrapClass:"delete-all-dialog",
                time: 2000
            });
            window.console && console.log(picob);
        }
    }

    function addImg(picurl){
        var $tem = $(".edit-template").find(".drag-ele").clone();
        var div=$(".template");
        var sdiv=div.prev();
        sdiv.find("ul[data-tag='guideImgs']").append($tem);
        //$("ul[data-tag='guideImgs']").append($tem);
        $tem.find("img").attr("src","http://pic.lvmama.com/"+picurl);
        $tem.find("input[name='imgurls']").val("http://pic.lvmama.com/"+picurl);
        $tem.attr("data-pic",picurl);
        return true;
    }
    
    function addImg2(picurl){
        var $tem = $(".edit-template").find(".drag-ele").clone();
        var div=$(".template");
        var sdiv=div.prev();
        sdiv.find("ul[data-tag='guideImgs']").append($tem);
        //$("ul[data-tag='guideImgs']").append($tem);
        $tem.find("img").attr("src",picurl);
        $tem.find("input[name='imgurls']").val(picurl);
        $tem.attr("data-pic",picurl);
        return true;
    }
  
</script>
</body>
</html>