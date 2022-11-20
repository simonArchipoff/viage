#ifndef LIST_MODEL_H
#define LIST_MODEL_H

#include "List/c_list.hpp"
#include <QAbstractListModel>
#include <wobjectdefs.h>

namespace Data
{
//template <typename T>
//class c_list;

template <typename T>
class list_model : public QAbstractListModel
{
    W_OBJECT(list_model)

public:
    explicit list_model(QObject* parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    bool setData(const QModelIndex &index,
                 const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    c_list<T>* list() const;
    void setList(c_list<T>* newList);

    W_PROPERTY(c_list<T>*, list READ list WRITE setList)

protected:
    c_list<T>* m_list{nullptr};
};
}

#include "list_model.cpp"
#endif // LIST_MODEL_H
