<!--插入图片 开始-->
    <div class="pf-insert-picture" style="width:550px;height:260px">

        <div class="pf-insert-header">
            图片模板：
            <a id="btn1" class="btn btn-primary" >1张图</a>
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
                    <div class="picture" data-id="11" data-width="1080" data-height="432" data-fixed-width="true" style="width:756px;height:302px"
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
                        <li class="picture" data-id="21" data-width="530" data-height="353" data-fixed-width="true" style="width:371px;height:247px"
                            data-fixed-height="true">
                            <img id="imgInsert21" style="width:371px;height:247px">
                            <div class="shadow"></div>
                            <div class="re-choice"></div>
                            <div class="choice">选择图片
                            </div>
                        </li>
                        <li class="picture" data-id="22" data-width="530" data-height="353" data-fixed-width="true" style="width:371px;height:247px"
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
                        <li class="picture" data-id="31" data-width="347" data-height="231" data-fixed-width="true" style="width:243px;height:162px"
                            data-fixed-height="true">
                            <img id="imgInsert31" style="width:243px;height:162px">
                            <div class="shadow"></div>
                            <div class="re-choice"></div>
                            <div class="choice">选择图片
                            </div>
                        </li>
                        <li class="picture" data-id="32" data-width="347" data-height="231" data-fixed-width="true" style="width:243px;height:162px"
                            data-fixed-height="true">
                            <img id="imgInsert32" style="width:243px;height:162px">
                            <div class="shadow"></div>
                            <div class="re-choice"></div>
                            <div class="choice">选择图片
                            </div>
                        </li>
                        <li class="picture" data-id="33" data-width="347" data-height="231" data-fixed-width="true" style="width:243px;height:162px"
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
                        <div class="multiple-picture picture" data-id="41" data-width="1080" data-height="432" data-fixed-width="true" style="width:756px;height:302px"
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
                          
                                <li class="upload-item-new JS_multiple_picture_add picture_add_end" style="width:215px;height:164px;">
                                    <i></i>
                                                                                                 添加图片
                                </li>
                            </ol>
                            <p class="multiple-picture-list-info">
                                                                                   无版权图片慎用，一经发生版权纠纷，责任自负！&ensp;&ensp;&ensp;共 <span>0张图片。</span>
                                <a class="btn JS_multiple_picture_add" style="margin-left:580px;margin-top:-25px;width:70px;">添加图片</a>
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
    <!--插入图片 结束-->
    <!--自定义图片批量开始-->
    <div  id="divInsetrBatch4" class="pf-insert-pane">
        <li class="upload-item" style="width:215px;height:200px;">
            <div class="upload-item-picture" style="width:215px;height:164px;">
                <img src="http://placehold.it/246x164/CCC" alt=""  style="width:215px;height:164px;">
            </div>
            <div class="upload-item-mask" style="width:215px;height:200px;"></div>
            <div class="upload-item-delete">删除</div>
            <p class="imgName"></p>
        </li>
    </div>
    <!--自定义图片批量结束-->
    
	<!--图片1模板 开始-->
	<div class="pf-movable pf-movable-picture-one" data-class="pf-movable-picture-one" featPropType="IMG">
	    <input type="hidden" value="001" name="movableId">
	    <label class="pf-label">
	        <i class="pf-label-icon"></i>
	        图片：
	    </label>
	    <div class="pf-content">
	        <ul class="yin-section-img yin-section-img-large clearfix">
	            <li>
	                <img name="img11" src="http://placehold.it/1080x432/CCCCCC" alt="" width="1080" height="432">
	            </li>
	        </ul>
	
	    </div>
	    <div class="pf-btn-box">
	        <a class="pf-btn btn-primary btn JS_movable_edit">编辑</a>
	        <a class="pf-btn btn JS_movable_del">删除</a>
	        <label>
                <input type="radio" name="product-insert-position">
                                          选择插入
            </label>
	    </div>
	</div>
	<!--图片1模板 结束-->
	
	<!--图片1带标题模板 开始-->
	<div class="pf-movable pf-movable-picture-one-with-title" data-class="pf-movable-picture-one-with-title" featPropType="IMG">
	    <input type="hidden" value="001" name="movableId">
	    <label class="pf-label">
	        <i class="pf-label-icon"></i>
	        图片：
	    </label>
	    <div class="pf-content">
	        <ul class="yin-section-img yin-section-img-large clearfix">
	            <li>
	                <img name="img12" src="http://placehold.it/1080x432/CCCCCC" alt="" width="1080" height="432" >
	                <p>产品名称产品名称产品名称产品名称产品名称最多字符限制30个字符</p>
	            </li>
	        </ul>
	
	    </div>
	    <div class="pf-btn-box">
	        <a class="pf-btn btn-primary btn JS_movable_edit">编辑</a>
	        <a class="pf-btn btn JS_movable_del">删除</a>
	         <label>
                    <input type="radio" name="product-insert-position">
                                                   选择插入
             </label>
	    </div>
	</div>
	<!--图片1带标题模板 结束-->
	
	<!--图片2模板 开始-->
	<div class="pf-movable pf-movable-picture-two" data-class="pf-movable-picture-two" featPropType="IMG">
	    <input type="hidden" value="001" name="movableId">
	    <label class="pf-label">
	        <i class="pf-label-icon"></i>
	        图片：
	    </label>
	    <div class="pf-content">
	        <ul class="yin-section-img yin-section-img-big clearfix">
	            <li>
	                <img name="img21" src="http://placehold.it/530x353/CCCCCC" alt="" width="530" height="353">
	            </li>
	            <li>
	                <img name="img22" src="http://placehold.it/530x353/CCCCCC" alt="" width="530" height="353">
	            </li>
	        </ul>
	
	    </div>
	    <div class="pf-btn-box">
	        <a class="pf-btn btn-primary btn JS_movable_edit">编辑</a>
	        <a class="pf-btn btn JS_movable_del">删除</a>
	         <label>
                   <input type="radio" name="product-insert-position">
                                                  选择插入
             </label>
	    </div>
	</div>
	<!--图片2模板 结束-->
	
	<!--图片3模板 开始-->
	<div class="pf-movable pf-movable-picture-three" data-class="pf-movable-picture-three" featPropType="IMG">
	    <input type="hidden" value="001" name="movableId">
	    <label class="pf-label">
	        <i class="pf-label-icon"></i>
	        图片：
	    </label>
	    <div class="pf-content">
	        <ul class="yin-section-img yin-section-img-small clearfix">
	            <li>
	                <img name="img31" src="http://placehold.it/347x231/CCCCCC" alt="" width="347" height="231">
	            </li>
	            <li>
	                <img name="img32" src="http://placehold.it/347x231/CCCCCC" alt="" width="347" height="231">
	            </li>
	            <li>
	                <img name="img33" src="http://placehold.it/347x231/CCCCCC" alt="" width="347" height="231">
	            </li>
	        </ul>
	
	    </div>
	    <div class="pf-btn-box">
	        <a class="pf-btn btn-primary btn JS_movable_edit">编辑</a>
	        <a class="pf-btn btn JS_movable_del">删除</a>
	         <label>
                    <input type="radio" name="product-insert-position">
                                                    选择插入
             </label>
	    </div>
	</div>
	<!--图片3模板 结束-->
	
	<!--图片1不确定高度模板 开始-->
	<div class="pf-movable pf-movable-picture-custom" data-class="pf-movable-picture-custom" featPropType="IMG">
	    <input type="hidden" value="001" name="movableId">
	    <label class="pf-label">
	        <i class="pf-label-icon"></i>
	        图片：
	    </label>
	    <div class="pf-content">
	        <ul class="yin-section-img yin-section-img-diy clearfix">
	            <li>
	                <img name="img41" src="http://placehold.it/1080x540/CCCCCC" alt="" width="1080">
	            </li>
	        </ul>
	
	    </div>
	    <div class="pf-btn-box">
	        <a class="pf-btn btn-primary btn JS_movable_edit">编辑</a>
	        <a class="pf-btn btn JS_movable_del">删除</a>
	         <label>
                    <input type="radio" name="product-insert-position">
                                                     选择插入
             </label>
	    </div>
	</div>
	<!--图片1不确定高度模板 结束-->