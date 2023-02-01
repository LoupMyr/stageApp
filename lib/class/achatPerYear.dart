class AchatPerYear {
  AchatPerYear(this._annee, this._total);

  String _annee;
  double _total;

  String getAnnee() {
    return this._annee;
  }

  void setAnnee(String newAnnee) {
    this._annee = newAnnee;
  }

  double getTotal() {
    return this._total;
  }

  void setTotal(double newTotal) {
    this._total = newTotal;
  }
}
