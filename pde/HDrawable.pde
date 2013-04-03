public static abstract class HDrawable implements HFollower, HFollowable {
	protected HDrawable _parent;
	protected HBundle _extras;
	protected HChildSet _children;
	protected float _x, _y, _drawX, _drawY, _width, _height,
		_rotationRad, _strokeWeight, _alpha;
	protected int _fill, _stroke, _strokeCap, _strokeJoin;
	public HDrawable() {
		_alpha = 1;
		_fill = H.DEFAULT_FILL;
		_stroke = H.DEFAULT_STROKE;
		_strokeCap = PConstants.ROUND;
		_strokeJoin = PConstants.MITER;
		_strokeWeight = 1;
	}
	public void copyPropertiesFrom(HDrawable other) {
		_x = other._x;
		_y = other._y;
		_drawX = other._drawX;
		_drawY = other._drawY;
		_width = other._width;
		_height = other._height;
		_rotationRad = other._rotationRad;
		_alpha = other._alpha;
		_strokeWeight = other._strokeWeight;
		_fill = other._fill;
		_stroke = other._stroke;
		_strokeCap = other._strokeCap;
		_strokeJoin = other._strokeJoin;
	}
	public abstract HDrawable createCopy();
	public void _set_parent_(HDrawable newParent) {
		_parent = newParent;
	}
	public HDrawable parent() {
		return _parent;
	}
	public HChildSet children() {
		return _children;
	}
	public int numChildren() {
		if(_children==null)
			return 0;
		return _children.getLength();
	}
	public boolean hasChildren() {
		return _children!=null && _children.getLength()>0;
	}
	public HDrawable add(HDrawable child) {
		if(_children==null)
			_children = new HChildSet(this);
		_children.add(child);
		return child;
	}
	public HDrawable remove(HDrawable child) {
		if(_children!=null)
			_children.remove(child);
		return child;
	}
	public HIterator<HDrawable> iterator() {
		return _children.iterator();
	}
	public HDrawable loc(float newX, float newY) {
		_x = newX;
		_y = newY;
		return this;
	}
	public HDrawable loc(PVector pt) {
		_x = pt.x;
		_y = pt.y;
		return this;
	}
	public PVector loc() {
		return new PVector(_x,_y);
	}
	public HDrawable x(float newX) {
		_x = newX;
		return this;
	}
	public float x() {
		return _x;
	}
	public HDrawable y(float newY) {
		_y = newY;
		return this;
	}
	public float y() {
		return _y;
	}
	public HDrawable move(float dx, float dy) {
		_x += dx;
		_y += dy;
		return this;
	}
	public HDrawable locAt(int where) {
		if(_parent!=null) {
			if(HMath.containsBits(where,H.CENTER_X))
				_x = _parent.width()/2 + _parent._drawX;
			else if(HMath.containsBits(where,H.LEFT))
				_x = _parent._drawX;
			else if(HMath.containsBits(where,H.RIGHT))
				_x = _parent.width() + _parent._drawX;
			if(HMath.containsBits(where,H.CENTER_Y))
				_y = _parent.height()/2 + _parent._drawY;
			else if(HMath.containsBits(where,H.TOP))
				_y = _parent._drawY;
			else if(HMath.containsBits(where,H.BOTTOM))
				_y = _parent.height() + _parent._drawY;
		}
		return this;
	}
	public HDrawable anchor(float ax, float ay) {
		_drawX = -ax;
		_drawY = -ay;
		return this;
	}
	public HDrawable anchor(PVector pt) {
		_drawX = -pt.x;
		_drawY = -pt.y;
		return this;
	}
	public PVector anchor() {
		return new PVector(-_drawX,-_drawY);
	}
	public HDrawable anchorX(float ax) {
		_drawX = -ax;
		return this;
	}
	public float anchorX() {
		return -_drawX;
	}
	public HDrawable anchorY(float ay) {
		_drawY = -ay;
		return this;
	}
	public float anchorY() {
		return -_drawY;
	}
	public HDrawable anchorAt(int where) {
		if(HMath.containsBits(where,H.CENTER_X))
			_drawX = -_width/2;
		else if(HMath.containsBits(where,H.LEFT))
			_drawX = 0;
		else if(HMath.containsBits(where,H.RIGHT))
			_drawX = -_width;
		if(HMath.containsBits(where,H.CENTER_Y))
			_drawY = -_height/2;
		else if(HMath.containsBits(where,H.TOP))
			_drawY = 0;
		else if(HMath.containsBits(where,H.BOTTOM))
			_drawY = -_height;
		return this;
	}
	public HDrawable size(float w, float h) {
		width(w);
		height(h);
		return this;
	}
	public HDrawable size(float s) {
		size(s,s);
		return this;
	}
	public PVector size() {
		return new PVector(_width,_height);
	}
	public HDrawable width(float w) {
		if(_width != 0) 
			_drawX *= w/_width;
		_width = w;
		return this;
	}
	public float width() {
		return _width;
	}
	public HDrawable height(float h) {
		if(_height != 0) 
			_drawY *= h/_height;
		_height = h;
		return this;
	}
	public float height() {
		return _height;
	}
	public HDrawable scale(float s) {
		size(_width*s, _height*s);
		return this;
	}
	public HDrawable scale(float sw, float sh) {
		size(_width*sw, _height*sh);
		return this;
	}
	public PVector boundingSize() {
		PApplet app = H.app();
		float cosVal = app.cos(_rotationRad);
		float sinVal = app.sin(_rotationRad);
		float x1 = _drawX;			
		float x2 = _width + _drawX;	
		float y1 = _drawY;			
		float y2 = _height + _drawY;
		float[] xCoords = new float[4];
		float[] yCoords = new float[4];
		xCoords[0] = x1*cosVal + y1*sinVal;
		yCoords[0] = x1*sinVal + y1*cosVal;
		xCoords[1] = x2*cosVal + y1*sinVal;
		yCoords[1] = x2*sinVal + y1*cosVal;
		xCoords[2] = x1*cosVal + y2*sinVal;
		yCoords[2] = x1*sinVal + y2*cosVal;
		xCoords[3] = x2*cosVal + y2*sinVal;
		yCoords[3] = x2*sinVal + y2*cosVal;
		float minX = xCoords[3];
		float maxX = minX;
		float minY = yCoords[3];
		float maxY = maxX;
		for(int i=0; i<3; ++i) {
			float x = xCoords[i];
			float y = yCoords[i];
			if(x < minX) minX = x;
			else if(x > maxX) maxX = x;
			if(y < minY) minY = y;
			else if(y > maxY) maxY = y;
		}
		return new PVector(maxX-minX, maxY-minY);
	}
	public HDrawable fill(int clr) {
		_fill = clr;
		return this;
	}
	public HDrawable fill(int clr, int alpha) {
		_fill = HColorUtil.setAlpha(clr,alpha);
		return this;
	}
	public HDrawable fill(int r, int g, int b) {
		_fill = HColorUtil.merge(255,r,g,b);
		return this;
	}
	public HDrawable fill(int r, int g, int b, int a) {
		_fill = HColorUtil.merge(a,r,g,b);
		return this;
	}
	public int fill() {
		return _fill;
	}
	public HDrawable stroke(int clr) {
		_stroke = clr;
		return this;
	}
	public HDrawable stroke(int clr, int alpha) {
		_stroke = HColorUtil.setAlpha(clr,alpha);
		return this;
	}
	public HDrawable stroke(int r, int g, int b) {
		_stroke = HColorUtil.merge(255,r,g,b);
		return this;
	}
	public HDrawable stroke(int r, int g, int b, int a) {
		_stroke = HColorUtil.merge(r,g,b,a);
		return this;
	}
	public int stroke() {
		return _stroke;
	}
	public HDrawable strokeCap(int type) {
		_strokeCap = type;
		return this;
	}
	public int strokeCap() {
		return _strokeCap;
	}
	public HDrawable strokeJoin(int type) {
		_strokeJoin = type;
		return this;
	}
	public int strokeJoin() {
		return _strokeJoin;
	}
	public HDrawable strokeWeight(float f) {
		_strokeWeight = f;
		return this;
	}
	public float strokeWeight() {
		return _strokeWeight;
	}
	public HDrawable rotation(float deg) {
		_rotationRad = deg * H.D2R;
		return this;
	}
	public float rotation() {
		return _rotationRad * H.R2D;
	}
	public HDrawable rotationRad(float rad) {
		_rotationRad = rad;
		return this;
	}
	public float rotationRad() {
		return _rotationRad;
	}
	public HDrawable rotate(float deg) {
		_rotationRad += deg * H.D2R;
		return this;
	}
	public HDrawable rotateRad(float rad) {
		_rotationRad += rad;
		return this;
	}
	public HDrawable alpha(int a) {
		return alphaPerc(a/255f);
	}
	public int alpha() {
		return H.app().round( alphaPerc()*255 );
	}
	public HDrawable alphaPerc(float aPerc) {
		_alpha = (aPerc<0)? 0 : (aPerc>1)? 1 : aPerc;
		return this;
	}
	public float alphaPerc() {
		return (_alpha<0)? 0 : _alpha;
	}
	public HDrawable visibility(boolean v) {
		if(v && _alpha == 0) {
			_alpha = 1;
		} else if(v == _alpha < 0) {
			_alpha = -_alpha;
		}
		return this;
	}
	public boolean visibility() {
		return _alpha > 0;
	}
	public HDrawable show() {
		return visibility(true);
	}
	public HDrawable hide() {
		return visibility(false);
	}
	public HDrawable alphaShift(int da) {
		return alphaShiftPerc( da/255f );
	}
	public HDrawable alphaShiftPerc(float daPerc) {
		return alphaPerc(_alpha + daPerc);
	}
	public float followerX() {
		return _x;
	}
	public float followerY() {
		return _y;
	}
	public float followableX() {
		return _x;
	}
	public float followableY() {
		return _y;
	}
	public void follow(float dx, float dy) {
		move(dx,dy);
	}
	public HDrawable extras(HBundle b) {
		_extras = b;
		return this;
	}
	public HBundle extras() {
		return _extras;
	}
	public float[] abs2rel(float x, float y) {
		return null;
	}
	public float[] rel2abs(float x, float y) {
		return null;
	}
	public void set(int propId, float val) {
		switch(propId) {
		case H.WIDTH:		width(val); break;
		case H.HEIGHT:		height(val); break;
		case H.SIZE:		size(val); break;
		case H.ALPHA:		alpha(H.app().round(val)); break;
		case H.X:			x(val); break;
		case H.Y:			y(val); break;
		case H.LOCATION:	loc(val,val); break;
		case H.ROTATION:	rotation(val); break;
		case H.DROTATION:	rotate(val); break;
		case H.DX:			move(val,0); break;
		case H.DY:			move(0,val); break;
		case H.DLOC:		move(val,val); break;
		case H.SCALE:		scale(val); break;
		default: break;
		}
	}
	protected void applyStyle(PApplet app, float currAlphaPerc) {
		int falpha = _fill>>>24;
		falpha = app.round( currAlphaPerc * falpha ) << 24;
		int currFill = _fill & 0x00FFFFFF | falpha;
		app.fill(currFill);
		if(_strokeWeight > 0) {
			int salpha = _stroke>>>24;
			salpha = app.round( currAlphaPerc * salpha ) << 24;
			int currStroke = _stroke & 0x00FFFFFF | salpha;
			app.stroke(currStroke);
			app.strokeWeight(_strokeWeight);
			app.strokeCap(_strokeCap);
			app.strokeJoin(_strokeJoin);
		} else app.noStroke();
	}
	public void paintAll(PApplet app, float currAlphaPerc) {
		if(_alpha<=0 || _width<=0 || _height<=0) return;
		app.pushMatrix();
			app.translate(_x,_y);
			app.rotate(_rotationRad);
			currAlphaPerc *= _alpha;
			draw(app,_drawX,_drawY,currAlphaPerc);
			if(hasChildren()) {
				HIterator<HDrawable> it = _children.iterator();
				while(it.hasNext()) it.next().paintAll(app,currAlphaPerc);
			}
		app.popMatrix();
	}
	public abstract void draw(
		PApplet app, float drawX, float drawY, float currAlphaPerc);
}
