class _PConst{
    final value;
    _PConst(this.value);

    String toString() => "Pconst($value)";
}

PConst(int value){
  return new _PConst(value);
}

