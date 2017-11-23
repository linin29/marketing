var Annotation = (function(){
    var $container = void(0);
    var default_annotation_enabled = void(0), annotation_enabled = void(0);
    var tempRect = void(0);
    var canvasContainerCoords = void(0);
    var canvas = void(0);
    var top = 0, left = 0, bottom = 0, right = 0, base_ratio = 0, ratio = 1, scale = 1, mouseWheelFlag = false, mouseMoveFlag = false, scalingObjFlag = false;
    var $canvas = $('#canvas');
    var $showContainer = $('#show_area');
    var base_width = $showContainer.width(), base_height = $showContainer.height();
    var min_width = $showContainer.attr('min_width'), min_height = $showContainer.attr('min_height');
    var originResData = [];
    var current_action = void(0);
    var mouseNotDown = void(0);
    var ImageLoading = void(0);
    var color = '#f00';

    var ACTION = {
        RESIZE: 'resize',
        DRAW: 'draw',
        MOVING: 'moving',
        HOVER: 'hover',
        SCALING: 'scaling'
    }

    function reRenderImage(asset_path, asset_annotations) {
        var __renderCallback = function(img){
            canvas.clear();
            canvas.setBackgroundColor('#dcdcdc');
            canvas.renderAll();

            var imgWidth = img.getOriginalSize().width;
            var imgHeight = img.getOriginalSize().height;
            var size = adjust(imgWidth, imgHeight, canvas.width, canvas.height);

            if(size.width == canvas.width) {
                img.scaleToWidth(canvas.width);
            } else {
                img.scaleToHeight(canvas.height);
            }

            canvas.setBackgroundImage(img, canvas.renderAll.bind(canvas));

            ratio = img.scaleX;
            if (base_ratio == 0) base_ratio = img.scaleX;

            if(size.width == canvas.width) {
                img.set({'top': (canvas.height - img.height * ratio) / 2});
            } else {
                img.set({'left': (canvas.width - img.width * ratio) / 2});
            }

            top = img.top;
            left = img.left;
            bottom = top + img.height * ratio;
            right = left + img.width * ratio;
            
            $.each(asset_annotations, function(index, annotation) {
                var rect = createRect({'left': annotation.x * ratio + left, 'top': annotation.y * ratio + top,
                                    'width': annotation.width * ratio, 'height': annotation.height * ratio,
                                    'angle': annotation.angle ? annotation.angle : 0, 'id': new Date().getTime(), 
                                    'label': annotation.label});
                if (annotation.label === 0){
                    rect.visible = false;
                }
                canvas.add(rect);
            });

            canvas.renderAll();

            mouseWheelFlag = false;
        };

        fabric.Image.fromURL(asset_path, __renderCallback);
    }

    function adjust(imgWidth, imgHeight, containerWidth, containerHeight) {
        var containerRatio = containerWidth / containerHeight;
        var imgRatio = imgWidth / imgHeight;

        if (imgRatio > containerRatio) {
            imgWidth = containerWidth;
            imgHeight = containerWidth / imgRatio;
        } else if (imgRatio < containerRatio) {
            imgHeight = containerHeight;
            imgWidth = containerHeight * imgRatio;
        } else {
            imgWidth = containerWidth;
            imgHeight = containerHeight;
        }

        return {'width': imgWidth, 'height': imgHeight};
    }

    function createRect(data) {
        return new fabric.Rect({
            left: data.left,
            top: data.top,
            width: data.width,
            height: data.height,
            angle: data.angle,
            fill: 'rgba(0, 0, 0, 0)',
            strokeWidth: 2,
            stroke: color,
            borderColor: '#39f',
            cornerColor: '#39f',
            cornerSize: 6,
            transparentCorners: false,
            id: data.id,
            label: data.label,
            selectable: true,
            hasRotatingPoint: false
        });
    }

    function getCanvasAnnotationData(){
        var annotations = [];

        canvas.forEachObject(function(obj) {
            if (obj.text || obj.type === 'line'){
                return;
            }

            var annotation = {'x': Math.round((obj.left - left) / ratio), 'y': Math.round((obj.top - top) / ratio),
                        'width': Math.round(obj.width * obj.scaleX  / ratio), 'height': Math.round(obj.height * obj.scaleY / ratio),
                        'angle': obj.angle, 'label': obj.label, 'id': obj.tracking_id};

            annotations.push(annotation);
        });

        modified_rect_set = {};
        return annotations;
    }

    function _set_options(k, v){
        if (k === 'annotation_enabled'){
            default_annotation_enabled = annotation_enabled = v;
        } else if ((typeof v=='string') && v.constructor==String){ //string type
            eval(k + '="' + v + '"');
        } else {
            eval(k + '=' + v);
        }
    }

    function getOffsetX(e){
        var offsetX = 0;

        if (e.pageX < canvasContainerCoords.left){
            offsetX = left;
        } else if (e.pageX > canvasContainerCoords.right){
            offsetX = right;
        } else {
            offsetX = e.offsetX;
            if (offsetX < left){
                offsetX = left;
            } else if (offsetX > right){
                offsetX = right;
            }
        }

        return offsetX;
    }

    function getOffsetY(e){
        var offsetY = 0;

        if (e.pageY < canvasContainerCoords.top){
            offsetY = top;
        } else if (e.pageY > canvasContainerCoords.bottom){
            offsetY = bottom - 3;
        } else {
            offsetY = e.offsetY;
            if (offsetY < top){
                offsetY = top;
            } else if (offsetY > bottom){
                offsetY = bottom - 3;
            }
        }

        return offsetY;
    }

    function getCanvasContainerCoords(){
        var $canvasContainer = $('#show_area')[0];

        var coords = {
                'top': $canvasContainer.offsetTop - 20,
                'left': $canvasContainer.offsetLeft,
                'bottom': $canvasContainer.offsetTop + $canvasContainer.offsetHeight - 20,
                'right': $canvasContainer.offsetLeft + $canvasContainer.offsetWidth,
                'width': $canvasContainer.offsetWidth,
                'height': $canvasContainer.offsetHeight
            };

        return coords;
    }

    function getAction(){
        if($showContainer.data('drawRect')){
            return ACTION.DRAW;
        } else {
            return current_action;
        }
    }

    var __initEvent = function(){

        canvas.on('mouse:move', function(options) {
            if (mouseMoveFlag) return;

            mouseMoveFlag = true;

            var action = getAction();
            if (action === ACTION.DRAW) {
                var oldCoords = $showContainer.data('oCoords');
                var oldOffsetX = oldCoords.offsetX;
                var oldOffsetY = oldCoords.offsetY;

                if(Math.abs(oldOffsetX - options.e.offsetX) < 6 || Math.abs(oldOffsetY - options.e.offsetY) < 6){
                    mouseMoveFlag = false;
                    return;
                }

                if (tempRect){
                    canvas.remove(tempRect);
                }

                var offsetX = getOffsetX(options.e), offsetY = getOffsetY(options.e);
                tempRect = createRect({'left': Math.min(oldOffsetX, offsetX),
                                        'top': Math.min(oldOffsetY, offsetY),
                                        'width': Math.abs(offsetX - oldOffsetX),
                                        'height': Math.abs(offsetY - oldOffsetY),
                                        'angle': 0, 'label': null, 'id': 0});
                canvas.add(tempRect);
                canvas.renderAll();
            }

            mouseMoveFlag = false;
        });

        canvas.on('mouse:down', function(options) {
            if(!annotation_enabled)  return;
            
            if(options.target) {
                $showContainer.data('drawRect', false);
                
                //TODO:click event
                $('#labelPanel').show();
                $('#skuType').val($("#skuType option[skuorder=" + (parseInt(options.target.label) - 1) + "]").val()).select2();
                return;
            }

            var x = options.e.offsetX, y = options.e.offsetY;
            if (x < left || x > right || y < top || y > bottom){
                mouseNotDown = true;
                return;
            }

            $showContainer.data('drawRect', true);
            $showContainer.data('oCoords', {'offsetX': options.e.offsetX, 'offsetY': options.e.offsetY});
        });

        canvas.on('mouse:up', function(options) {
            if (!annotation_enabled)  return;

            if (mouseNotDown){
                mouseNotDown = false;
                return;
            }
            
            if (!$showContainer.data('drawRect')){
            	return;
            }

            if (tempRect){
                canvas.remove(tempRect);
            }

            var oldCoords = $showContainer.data('oCoords');
            var oldOffsetX = oldCoords.offsetX;
            var oldOffsetY = oldCoords.offsetY;

            if(Math.abs(oldOffsetX - options.e.offsetX) < 6 || Math.abs(oldOffsetY - options.e.offsetY) < 6){
                $showContainer.data('drawRect', false);
                return;
            }

            //TODO:show label select
            $('#labelPanel').show();
            $('#skuType').val("").select2();
            var offsetX = getOffsetX(options.e), offsetY = getOffsetY(options.e);
            var rect = createRect({'left': Math.min(oldOffsetX, offsetX),
                                    'top': Math.min(oldOffsetY, offsetY),
                                    'width': Math.abs(offsetX - oldOffsetX),
                                    'height': Math.abs(offsetY - oldOffsetY),
                                    'angle': 0, 'id': new Date().getTime(), 'label': null
                                    });
            canvas.add(rect);
            canvas.setActiveObject(rect);
            canvas.renderAll();

            $showContainer.data('drawRect', false); //reset data
        });
    };

    function initCanvasContainerCoords(){
        canvasContainerCoords = getCanvasContainerCoords();
    }

    function initCanvasContainerSize(){
        var container_width = $('#image_default').width();
        var set_width = container_width * 0.77;
        
        if (set_width > min_width){
            $showContainer.css('width', set_width + 'px');
            base_width = set_width;
            $canvas.attr('width', set_width);

            var set_height = min_height / min_width * set_width;
            $showContainer.css('height', set_height + 'px');
            base_height = set_height;
            $canvas.attr('height', set_height);

            $('#tracking_obj_list').css('height', set_height+'px');
        }

        canvas = new fabric.Canvas('canvas');
        canvas.selection = false;
    }

    var init = function(){
        initCanvasContainerSize();
        __initEvent();
        initCanvasContainerCoords();
        annotation_enabled = true;
    };
    
    var deleteCrop = function(){
        var active = canvas.getActiveObject();
        canvas.remove(active);
    };
    
    var setAllData = function(path, annotations){
    	if(annotations && annotations.length > 0){
    		reRenderImage(path, annotations)
    	}
    };
    
    var getAllData = function(){
    	return getCanvasAnnotationData();
    };
    
    var getCropBoxData = function(){
    	var active = canvas.getActiveObject();
    	var cropObject = {};
    	cropObject.annotationId = active.id;
    	cropObject.x = active.left;
    	cropObject.y = active.top;
    	cropObject.width = active.width;
    	cropObject.height = active.height;
    	cropObject.angle = active.angle;
    	cropObject.label = active.label;
    	return cropObject;
    };
    
    var setLabel = function(label){
    	var active = canvas.getActiveObject();
    	active.label = label;
    }

    return {
        init : init,
        set : _set_options,
        initCanvasContainerCoords : initCanvasContainerCoords,
        deleteCrop : deleteCrop,
        setAllData : setAllData,
        getAllData : getAllData,
        getCropBoxData : getCropBoxData,
        setLabel : setLabel
    };
})();